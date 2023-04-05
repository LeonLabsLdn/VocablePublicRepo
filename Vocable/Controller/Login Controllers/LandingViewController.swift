import UIKit
import GoogleSignIn
import SafariServices

class LandingViewController: UIViewController{
    
    @IBOutlet weak var policiesLabel    : UILabel!
    @IBOutlet weak var buttonsView      : LoginButtonsView!
    let splash                          = SplashLoadingView()
    let customAlert                     = CustomAlertView()
    var name:String?
    var password:String?
    var email:String?
    
    override func viewWillAppear(_ animated: Bool) {
        Protocols.landingDelegate = self
        setupPolicies()
        if UserData.logout != true{
            splash.frame = view.frame
            view.addSubview(splash)
            LoadingAnimationView.shared.center = view.center
            view.addSubview(LoadingAnimationView.shared)
            customAlert.layer.opacity = 0
            customAlert.isHidden = true
            customAlert.closeButton.isHidden = true
            customAlert.actionLabel.isHidden = true
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            let topPadding = window!.safeAreaInsets.top
            customAlert.frame = CGRect(x: 5, y: topPadding + 5, width: self.view.frame.width - 10, height: 60)
            view.addSubview(customAlert)
            self.loginCheck()
        }
    }
    func openURL(url:URL){
        let vc = SFSafariViewController(url: url);present(vc, animated: true, completion: nil)
    }
    func setupPolicies(){
        policiesLabel.attributedText = Helpers.shared.landingPolicyAtttString()
        policiesLabel.isUserInteractionEnabled = true
        policiesLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    @objc func tapLabel(gesture: UITapGestureRecognizer){
        if gesture.didTapAttributedTextInLabel(label: policiesLabel, inRange: Constants.termsRange) || gesture.didTapAttributedTextInLabel(label: policiesLabel, inRange: Constants.termsRange2) {
            openURL(url: URL(string: Constants.serviceTermsURL)!)
        } else if gesture.didTapAttributedTextInLabel(label: policiesLabel, inRange: Constants.privacyRange) || gesture.didTapAttributedTextInLabel(label: policiesLabel, inRange: Constants.privacyRange2) {
            openURL(url: URL(string: Constants.privacyPolicyURL)!)
        }
    }
    func loginCheck(){
        destroyPart1Database()
        destroyPart2Database()
        DataModel.shared.createTable()
        do{
            let result = try Keychain.shared.search()
            if ConnectivityManager.checkNetworkStatus != false{
                print("im trying")
                LoginModel.shared.login(email: result["username"]!, name: "-", password: result["password"]!,auto: true, homeRefresh: false, language:"nil") { [self] value in
                    if value == true{
                        login()
                    }else{
                        deleteKeychain()
                    }
                }
            }else{
                UserData.offline = true
                login()
            }
        }catch{
deleteKeychain()
        }
    }
    
    func deleteKeychain(){
        do{
            try Keychain.shared.delete()
            UserDefaults.standard.setValue(true, forKey: "updated")
            UserDefaults.standard.setValue("", forKey: "gpic")
            splash.removeFromSuperview()
            LoadingAnimationView.shared.removeFromSuperview()
        }catch{
            UserDefaults.standard.setValue(true, forKey: "updated")
            UserDefaults.standard.setValue("", forKey: "gpic")
            splash.removeFromSuperview()
            LoadingAnimationView.shared.removeFromSuperview()
        }
    }
    
    func offline(){
        DispatchQueue.main.async{ [self] in present(
            AlertView.shared.offlineAlert(), animated: true, completion: nil)
        }
    }
    func login(){
        DispatchQueue.main.async {
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainController") as! UITabBarController
            NetworkModel.shared.retrieveProPractice()
            self.view.window?.rootViewController = mainViewController
            LoadingAnimationView.shared.removeFromSuperview()
            self.splash.removeFromSuperview()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let setup = segue.destination as? SetupViewController
        if segue.identifier == "languages"{
            setup?.email = email
            setup?.password = password
            setup?.name = name
        }
    }
}
extension LandingViewController:LandingDelegate{
    func linkLogin(email:String,name:String,password:String){
        PhraseData.shared.retrieveDailyPhrase()
        LoginModel.shared.login(email: email, name: name, password: password,auto: false, homeRefresh: false, language:"nil") { [self] value in
            if value == true{
                login()
            }
        }
    }
    func removeLoading(){
        splash.removeFromSuperview()
        LoadingAnimationView.shared.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    func relogin() {
        if ConnectivityManager.checkNetworkStatus == true{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginbutton", sender: self)
            }
        }else{
            self.offline()
        }
    }
    func landOffline() {
        offline()
    }
    func googleLogin() {
        addLoading()
        if ConnectivityManager.checkNetworkStatus == true{
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                guard error == nil else {
                    LoadingAnimationView.shared.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    return
                }
                guard let signInResult = signInResult else {
                    LoadingAnimationView.shared.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    return
                }
                let user = signInResult.user
                guard let emailAddress = user.profile?.email else {
                    LoadingAnimationView.shared.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    return
                }
                let givenName = user.profile?.givenName
                let picString = user.profile?.imageURL(withDimension: 200)?.absoluteString
                UserDefaults.standard.set(picString, forKey: "gpic")
                LoginModel.shared.loginCheck(emailLogin: false, email: emailAddress, name: givenName ?? "-", password: Helpers.shared.codeString())
            }
        }else{
            view.isUserInteractionEnabled = true
            LoadingAnimationView.shared.removeFromSuperview()
            self.offline()
        }
    }
    func loginError(){
        present(AlertView.shared.returnLinkAlert(), animated: true)
    }
    func addLoading(){
        view.isUserInteractionEnabled = false
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
    }
    func segueToLanguages(email:String,password:String,name:String){
        self.name = name
        self.password = password
        self.email = email
        self.performSegue(withIdentifier: "languages", sender: self)
    }
    func landingResult(loginResult:Bool) {
        if loginResult == true{
            PhraseData.shared.retrieveDailyPhrase()
            if "\(UserData.id)" != ""{
                NetworkModel.shared.updateUserData {_ in}
                view.isUserInteractionEnabled = true
                login()
            }else{
                view.isUserInteractionEnabled = true
                LoadingAnimationView.shared.removeFromSuperview()
                splash.removeFromSuperview()
                return
            }
        }else{
            view.isUserInteractionEnabled = true
            LoadingAnimationView.shared.removeFromSuperview()
            splash.removeFromSuperview()
            return
        }
    }
    func addWarning(){
        customAlert.topLabel.text = "This seems to be taking a while"
        customAlert.middleLabel.text = "Still trying to login, please wait a moment.."
        customAlert.middleLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        customAlert.isHidden = false
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {self.customAlert.alpha = 1}, completion: nil)
    }
}
