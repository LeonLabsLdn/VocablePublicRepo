import Alamofire
import AuthenticationServices

class LoginModel:NSObject,ASAuthorizationControllerDelegate{
    
    static let shared   = LoginModel()
    static let server   = "leonlabs.london"
    
    func login(email: String ,name: String, password: String, auto:Bool, homeRefresh:Bool, language:String, completion: @escaping (Bool) -> ()){
        print("logging in")
        let parameters: Parameters=["email":email, "name":name, "key":Constants.key,"password":password,"auto":auto,"language":language]
        AF.request("\(Constants.scriptAddress)login.php", method: .post, parameters: parameters).responseDecodable(of:loginResponse.self){ [] response in
            switch response.result {
            case.success(let value):
                PhraseData.shared.categoriesEng             = value.catEng
                PhraseData.shared.subCategoriesEng          = value.catSubEng
                PhraseData.shared.categoriesTranslated      = value.cat
                PhraseData.shared.subCategoriesTranslated   = value.catSub
                PhraseData.shared.faveTables                = value.catFave
                PhraseData.shared.faveSubcats               = value.catFaveSub
                UserData.lang                               = value.lang
                UserStats.lastLogin                         = "\(value.lastLogin) +0000"
                UserStats.now                               = value.date
                UserStats.streakCount                       = value.streakCount
                UserStats.streak                            = value.streak.components(separatedBy: ".")
                UserStats.stats                             = value.stats.components(separatedBy: ",").map { Int($0) ?? 0}
                UserData.id                                 = value.id
                UserData.name                               = value.displayName
                UserStats.xp                                = value.xp
                UserStats.lives                             = value.lives
                TranslateModel.shared.downloadModels()
                if PhraseData.shared.faveTables.count == 1 && PhraseData.shared.faveTables[0] == ""{PhraseData.shared.faveTables.remove(at: 0)}
                if UserDefaults.standard.string(forKey: "dID") == nil{PhraseData.shared.retrieveDailyPhrase()}
                if TimeModel.shared.checkDate() == true{
                    NetworkModel.shared.updateUserData {value in
                        completion(true)
                    }
                }
            case.failure(let error):
                print("login errror \(error)")
                completion(false)
                
            }
        }
    }
    struct loginResponse:Decodable{
        let id: Int
        let displayName: String
        let lastLogin: String
        let xp: Int
        let lives: Int
        let streak:String
        let streakCount:Int
        let stats:String
        let date:String
        let catFave:[String]
        let catFaveSub:[String]
        let catEng:[String]
        let catSubEng:[String]
        let cat:[String]
        let catSub:[String]
        let lang:String
    }
    struct emailResponse:Decodable{
        let message: String
    }
    
    func loginCheck(emailLogin: Bool, email: String, name: String, password: String){
        let parameters: Parameters=["email":email,"key":Constants.key]
        AF.request("\(Constants.scriptAddress)loginCheck.php", method: .post, parameters: parameters).responseDecodable(of:Bool.self) { [self] response in
            switch response.result{
            case .success(let value):
                if value == true{
                    self.login(email: email, name: name, password: password, auto: false, homeRefresh: false, language: "nil"){ [self] value in
                        if value == true{
                            if emailLogin != true{
                                do {
                                    try Keychain.shared.addcreds(username: email, password: password)
                                    Protocols.landingDelegate?.landingResult(loginResult: true)
                                }catch{
                                    Protocols.landingDelegate?.removeLoading()
                                }
                            }else{
                                UserData.exists = true
                                print("itexists")
                                verifyByEmail(email: email, password: password)
                            }
                        }else{
                            Protocols.landingDelegate?.removeLoading()
                        }
                    }
                }else{
                    if emailLogin != true{
                        Protocols.landingDelegate?.segueToLanguages(email:email,password:password,name:name)
                    }else{
                        UserData.exists = false
                        print("it doesnt exist")
                        verifyByEmail(email: email, password: password)
                    }
                }
            case .failure(let error):
                Protocols.landingDelegate?.removeLoading()
                print(error)
            }
        }
    }
    func verifyByEmail(email:String,password:String){
        UserData.email = email
        UserData.password = password
        UserData.vcode = Helpers.shared.codeString()
        let parameters: Parameters=["email":email, "key":Constants.key, "vcode":UserData.vcode!]
        AF.request("\(Constants.scriptAddress)mailLogin.php", method: .post, parameters: parameters).responseDecodable(of:emailResponse.self){ [] response in
            switch response.result{
            case.success(let value):
                print("we good \(value)")
                Protocols.loginVCDelegate?.returnLoginResult(result: true)
            case.failure(let error):
                print("the error is \(error)")
                Protocols.loginVCDelegate?.returnLoginResult(result: false)
            }
        }
        
    }
    func appleLogin(_:Any) -> Bool{
        Protocols.landingDelegate?.addLoading()
        if ConnectivityManager.checkNetworkStatus == true{
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            return true
        }
        Protocols.landingDelegate?.removeLoading()
        return false
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Protocols.landingDelegate?.removeLoading()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let givenName = appleIDCredential.fullName?.givenName ?? "-"
            var email = String()
            if "\(String(describing: appleIDCredential.email))" == "nil"{
                email = "\(userIdentifier)".replacingOccurrences(of: ".", with: "")
            }else{
                email = appleIDCredential.email!
            }
            LoginModel.shared.loginCheck(emailLogin: false, email: email, name: "\(givenName)", password: Helpers.shared.codeString())
        }else{
            Protocols.landingDelegate?.removeLoading()
        }
    }
    func deleteAcc(){
        let parameters: Parameters=["id":UserData.id,"key":Constants.key]
        AF.request("\(Constants.scriptAddress)rmvacc.php", method: .post, parameters: parameters).responseDecodable(of:String.self) { response in
            switch response.result{
            case .success(_):
                self.logout()
            case .failure(let error):
                print(error)
                Protocols.settingsDelegate?.removeLoading()
            }
        }
    }
    func updateUserName(name:String){
        let parameters: Parameters=["id":UserData.id,"name":name,"key":Constants.key]
        AF.request("\(Constants.scriptAddress)updateUserame.php", method: .post, parameters: parameters).responseDecodable(of:String.self) { response in
            switch response.result{
            case .success(_):
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    func logout(){
        do{
            try Keychain.shared.delete()
            Protocols.practiceDelegate?.hideSegmentedView()
            UserDefaults.standard.setValue("", forKey: "gpic")
            UserData.logout = true
            Protocols.settingsDelegate?.logoutSegue()
        }catch{
            Protocols.settingsDelegate?.removeLoading()
        }
    }
}
//                    if auto == "1"{
//                        if homeRefresh != true{
//                            Protocols.landingDelegate?.landingResult(loginResult: true)
//                            return
//                        }else{
//                            Protocols.homeDelegate?.homeLogin()
//                            return
//                        }
//                    }else if googleApple == "1"{
//                        do{
//                            try Keychain.shared.addcreds(username: email, password: password)
//                            Protocols.landingDelegate?.landingResult(loginResult: true)
//                            return
//                        }catch {
//                            do{
//                                try Keychain.shared.delete()
//                                Protocols.landingDelegate?.removeLoading();return
//                            }catch{
//                                Protocols.landingDelegate?.removeLoading();return
//                            }
//                        }
//                    }

