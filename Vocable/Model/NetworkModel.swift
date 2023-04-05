import Alamofire

class NetworkModel{
    
    static let shared = NetworkModel()

    func updateFave(table: String, row: String, sub: String){
        print("starting faves")
        let parameters: Parameters=["key":Constants.key,"id":"\(UserData.id)","table":"\(table)","row":"\(row)","sub":"\(sub)","lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)updateFavourites.php", method: .post, parameters: parameters).responseDecodable(of:Array<String>.self) {
            response in
            switch response.result {
            case.success(let value):
                print("this is value \(value)")
                UserData.isLoading.remove(at: UserData.isLoading.firstIndex(of: value.joined(separator: ",")) ?? 0)
                if UserDefaults.standard.string(forKey: "dTableNo") == value[0] && UserDefaults.standard.string(forKey: "dCatNo") == value[1] && UserDefaults.standard.string(forKey: "dID") == value[2]{
                    Protocols.homeDelegate?.updateFave(result:value[3])
                }
                PhraseData.shared.retrieveData { v in
                    Protocols.phraseDelegate?.updateFave(result: value)
                }
            case .failure(let error):
                print("THIS IS THE ERROR\(error)")
            }
        }
    }
    
    func generateProList(){
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)randomPick.php", method: .post, parameters: parameters).responseDecodable(of:Bool.self) { []
            response in
            switch response.result {
            case.success(_):
                self.retrieveProPractice()
            case.failure(let error):
                print (error)
                Protocols.practiceDelegate?.removeLoading()
            }
        }
    }
    
    func retrieveProPractice(){
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)getPracticeList.php", method: .post, parameters: parameters).responseDecodable(of:Array<Array<String>>.self) { []
            response in
            switch response.result {
            case.success(let value):
                if DataModel.shared.deleteProList() == true{
                    UserData.masteredTables = value[8].filter({ $0 != ""})
                    var count = 0
                    for _ in value[0]{
                        DataModel.shared.insertProList(
                            PROENG: value[0][count],
                            PROITA: value[1][count],
                            PROPRONOUNCE: value[2][count],
                            PROENGEXAMPLE: value[3][count],
                            PROITAEXAMPLE: value[4][count],
                            TABLENO: value[5][count],
                            ROWNO: value[6][count],
                            ANSWERCOUNT: value[7][count],
                            MASTERED: value[9][count])
                        count += 1
                    }
                    UserDefaults.standard.setValue(Int(value[10][0]), forKey: "totalRows")
                }
                UserData.catTotals = value[11]
                Protocols.profileDelegate?.updateStats()
                Protocols.practiceDelegate?.updatePStat()
                Protocols.practiceDelegate?.updatePracticeTV()
            case .failure(let error):
                Protocols.practiceDelegate?.removeLoading()
                print(error)
            }
        }
    }
    
    func updateUserData(completion: @escaping (Bool) -> ()) {
        let streakArr = UserStats.streak
        let streak = "\(streakArr.joined(separator: "."))"
        let stats = UserStats.stats.map({"\($0)"})
        let statsString = "\(stats.joined(separator: ","))"
        print(statsString)
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"xp":"\(UserStats.xp)", "lives":"\(UserStats.lives)", "streakCount":"\(UserStats.streakCount)", "streak":streak, "stats":statsString,"lang":UserData.lang,"ver":"\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"]
        AF.request("\(Constants.scriptAddress)updateUserData.php", method: .post, parameters: parameters).responseString {
            response in
            switch response.result {
            case.success(let value):
                print(value)
                completion (true)
            case.failure(let error):
                print(error)
                completion (true)
            }
        }
    }
    func updateProData(completion: @escaping (Bool) -> ()) {
        let streakArr = UserStats.streak
        let streak = "\(streakArr.joined(separator: "."))"
        let stats = UserStats.stats.map({"\($0)"})
        let statsString = "\(stats.joined(separator: ","))"
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"xp":"\(UserStats.xp)", "lives":"\(UserStats.lives)", "streakCount":"\(UserStats.streakCount)", "streak":streak, "proPoints":UserData.proPoints as NSArray,"stats":statsString,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)updateProData.php", method: .post, parameters: parameters).responseDecodable(of:Array<String>.self) {
            response in
            switch response.result {
            case.success(let value):
                if value.count != 0{
                    UserData.masteredData = value
                    print("this is mastered data\(UserData.masteredData)")
                    UserStats.stats[2] = UserStats.stats[2] + value.count
                    UserStats.stats[5] = UserStats.stats[5] + value.count
                }
                completion (true)
            case.failure(let error):
                print("ERROR \(error)")
                completion (true)
            }
        }
    }
    func report(message:String,subject:String){
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"userMessage":message,"subject":subject]
        AF.request("\(Constants.scriptAddress)report.php", method: .post, parameters: parameters).responseDecodable(of:Array<String>.self) {
            response in
            switch response.result {
            case.success(let value):print(value)
            case.failure(_):break
            }
        }
    }
    func updatePracticeList(row:String, table:String, refreshData:Bool,completion: @escaping (Bool) -> ()){
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"row":row,"table":table,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)updateProPracticeList.php", method: .post, parameters: parameters).responseString {
            response in
            switch response.result {
            case.success(let value):
                print("this is the value\(value)")
                if UserData.deletingStudyList == true{
                    Protocols.phraseDelegate?.retrieveData()
                    UserData.deletingStudyList = false
                }
                if refreshData == true{
                    self.retrieveProPractice()
                }
                completion(true)
                print(value)
            case.failure(let error):
                print("this is practice list error\(error)")
                completion(false)
            }
        }
    }
    func languageChange(completion: @escaping (Bool,Dictionary<String,String>) -> ()){
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key]
        AF.request("\(Constants.scriptAddress)getLanguageInfo.php", method: .post, parameters: parameters).responseDecodable(of:Dictionary<String,String>.self) {
            response in
            switch response.result {
            case.success(let value):
                completion(true,value)
            case.failure(let error):
                completion(false,["error" : "\(error)"])
            }
        }
    }
    func updateLanguage(language:String,completion: @escaping (Bool) -> ()){
        let parameters: Parameters=["id":"\(UserData.id)","key":Constants.key,"lang":language]
        AF.request("\(Constants.scriptAddress)updateLanguage.php", method: .post, parameters: parameters).responseDecodable(of:changeLanguageResponse.self) {
            response in
            switch response.result {
            case.success(let value):
                print(value)
                UserData.lang                               = language
                PhraseData.shared.categoriesTranslated      = value.cat
                PhraseData.shared.subCategoriesTranslated   = value.catSub
                PhraseData.shared.faveTables                = value.catFave
                PhraseData.shared.faveSubcats               = value.catFaveSub
                UserStats.lastLogin                         = "\(value.lastLogin) +0000"
                UserStats.now                               = value.date
                UserStats.streakCount                       = value.streakCount
                UserStats.streak                            = value.streak.components(separatedBy: ".")
                UserStats.stats                             = value.stats.components(separatedBy: ",").map { Int($0) ?? 0}
                UserStats.xp                                = value.xp
                UserStats.lives                             = value.lives
                TranslateModel.shared.downloadModels()
                if PhraseData.shared.faveTables.count == 1 && PhraseData.shared.faveTables[0] == ""{
                    PhraseData.shared.faveTables.remove(at: 0)
                }
                if TimeModel.shared.checkDate() == true{
                    NetworkModel.shared.updateUserData { [self] value in
                        retrieveProPractice()
                        PhraseData.shared.retrieveDailyPhrase()
                        Protocols.practiceDelegate?.updatePracticeTV()
                        Protocols.homeDelegate?.updateHomeQuiz()
                        Protocols.imageRecognitionDelegate?.popToRoot()
                        Protocols.translateDelegate?.popToRoot()
                        Protocols.phraseDelegate?.popToRoot()
                        Protocols.subCategoryDelegate?.popToRoot()
                        Protocols.categoriesDelegate?.reloadCatTableView()
                        Protocols.categoriesDelegate?.setViewLeft()
                        completion(true)
                    }
                }
            case.failure(let error):
                print("THIS IS THE ERROR \(error)")
                completion(false)
            }
        }
    }
    struct changeLanguageResponse:Decodable{
        let lastLogin: String
        let xp: Int
        let lives: Int
        let streak:String
        let streakCount:Int
        let stats:String
        let date:String
        let catFave:[String]
        let catFaveSub:[String]
        let cat:[String]
        let catSub:[String]
    }
    
    func checkFavouriteStatus(table: String, row: String, sub: String, completion: @escaping (String) -> ()){
            let parameters: Parameters=["id":"\(UserData.id)","table":"\(table)","row":"\(row)","sub":"\(sub)","key":Constants.key,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)checkFavourites.php", method: .post, parameters: parameters).responseDecodable(of:String.self) {
            response in
            switch response.result {
            case.success(let value):
                completion(value)
                case .failure(_):break}
        }
    }
}
