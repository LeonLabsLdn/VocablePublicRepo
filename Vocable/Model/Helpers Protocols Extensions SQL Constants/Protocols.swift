import Foundation

struct Protocols{
    static var quizProtocol:QuizProtocol?
    static var practiceDelegate:PracticeDelegate?
    static var homeDelegate:HomeDelegate?
    static var phraseDelegate:PhraseDelegate?
    static var categoriesDelegate:CategoriesDelegate?
    static var landingDelegate:LandingDelegate?
    static var loginVCDelegate:LoginVCDelegate?
    static var purchaseDelegate:PurchaseDelegate?
    static var settingsDelegate:SettingsDelegate?
    static var profileDelegate:ProfileDelegate?
    static var purchaseDescriptionDelegate:ProDescriptionDelegate?
    static var imageRecognitionDelegate:ImageRecognitionDelegate?
    static var translateDelegate:TranslateDelegate?
    static var subCategoryDelegate:SubCategoryDelegate?
}


protocol TranslateDelegate{
    func completeTranslate()
    func endTranscribe()
    func updateLabel(text:String)
    func authorisationFailed()
    func authorisationSuccess()
    func dismiss()
    func popToRoot()
}

protocol ImageRecognitionDelegate{
    func completeTranslate()
    func stopRunning()
    func startRunning()
    func dismiss()
    func popToRoot()
}

protocol ProDescriptionDelegate{
    func restoreCheck(state:Bool)
}

protocol SubCategoryDelegate{
    func popToRoot()
}

protocol ProfileDelegate{
    func updateStats()
    func offlineReload()
    func updateName(name:String)
}

protocol SettingsDelegate{
    func removeRestoreLoading(state:Bool)
    func removeLoading()
    func logoutSegue()
    func deleteAccount()
}

protocol CategoriesDelegate{
    func reloadCatTableView()
    func setViewLeft()
}

protocol LoginVCDelegate{
    func removeLoading()
    func returnLoginResult(result:Bool)
    func loginError()
    func segueToLanguages(email:String,password:String,name:String)
    func login(email:String,name:String,password:String)
}

protocol PhraseDelegate{
    func retrieveData()
    func popToRoot()
    func checkPhraseRow()
    func updateRow(pos:Int)
    func updateFave(result:[String])
    func addToStudy(row:String,pos:String)
    func selectFunc(pos:String)
    func selectFave(row:String,pos:String)
    func updatePhraseList()
    func showLoading()
}

protocol LandingDelegate{
    func addWarning()
    func googleLogin()
    func landOffline()
    func landingResult(loginResult:Bool)
    func relogin()
    func removeLoading()
    func loginError()
    func addLoading()
    func segueToLanguages(email:String,password:String,name:String)
    func linkLogin(email:String,name:String,password:String)
}

protocol QuizProtocol{
    func disableReport()
    func close()
    func updateButton(enable:Bool)
    func didFailWithError(error: Error)
    func incorrectAnswer()
    func dismissPractice()
    func startQuiz()
    func quitQuiz()
    func report()
    func reportSent()
}

protocol PracticeDelegate{
    func resetPracticeTVs()
    func masteredSectionTapped(add:Bool,section:Int)
    func masteredCellTapped(indexPath:IndexPath)
    func hideSegmentedView()
    func removeLoading()
    func addLoading()
    func removeMasteredView()
    func updatePracticeTV()
    func startQuiz(cat:String,isPro:Bool)
    func updatePStat()
}

protocol HomeDelegate{
    func setDataFunc()
    func proState()
    func updateFave(result:String)
    func faveLoading()
    func refreshContent()
    func updateDaily()
    func startQuiz(cat:String)
    func homeContentHeight(amount:CGFloat)
    func homeLayoutSubview()
    func resetUserData()
    func updateHomeQuiz()
    func setPrice()
    func homeLogout()
    func homeLogin()
}

protocol PurchaseDelegate{
    func restoreCheck(state:Bool)
    func reloadTableView()
    func dismissSelf()
    func removeLoading()
}
