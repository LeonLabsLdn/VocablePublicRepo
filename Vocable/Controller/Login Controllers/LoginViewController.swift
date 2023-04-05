import UIKit
import Foundation
import SafariServices

class LoginViewController: UIViewController{
    
    @IBOutlet weak var userString       : UITextField!
    @IBOutlet weak var loginButton      : UIButton!
    @IBOutlet weak var usernameView     : UIView!
    @IBOutlet weak var emailWarning     : UILabel!
    @IBOutlet weak var viewTop          : NSLayoutConstraint!
    @IBOutlet weak var privacyButton    : UIButton!
    @IBOutlet weak var policiesLabel    : UILabel!
    
    let emailPred               = NSPredicate(format:"SELF MATCHES %@", Constants.emailRegEx)
    var privayChecked           = false
    var textFieldAmount         : CGFloat?
    var email:String?
    var password:String?
    var name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPolicies()
        privacyButton.layer.borderWidth = 2
        privacyButton.layer.borderColor = #colorLiteral(red: 0.3882880211, green: 0.388091445, blue: 0.4011450112, alpha: 1)
        privacyButton.layer.cornerRadius = 3
        privacyButton.tintColor = .white
        Protocols.loginVCDelegate = self
        dismissKeyboard()
        loginButton.layer.opacity = 0.6
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        usernameView.layer.cornerRadius = usernameView.frame.size.height / 2
        usernameView.layer.borderWidth = 1
        usernameView.layer.borderColor = #colorLiteral(red: 0.8469871879, green: 0.8471065164, blue: 0.8469495177, alpha: 1)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserData.loginVC = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserData.loginVC = false
    }
    
    func openURL(url:URL){
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    func setupPolicies(){
        policiesLabel.text = Constants.policyText
        self.policiesLabel.textColor =  #colorLiteral(red: 0.2897919416, green: 0.2694565654, blue: 0.3088565767, alpha: 1)
        let underlineAttriString = NSMutableAttributedString(string: Constants.policyText)
        let range1 = (Constants.policyText as NSString).range(of: "Terms of Service")
        let range2 = (Constants.policyText as NSString).range(of: "Privacy Policy")
             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 11)!, range: range1)
             underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
   underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 11)!, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1), range: range2)
        policiesLabel.attributedText = underlineAttriString
        policiesLabel.isUserInteractionEnabled = true
        policiesLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer){
        let termsRange = (Constants.policyText as NSString).range(of: "Terms of Service")
        let privacyRange = (Constants.policyText as NSString).range(of: "Privacy Policy")
        if gesture.didTapAttributedTextInLabel(label: policiesLabel, inRange: termsRange) {
            openURL(url: URL(string: Constants.serviceTermsURL)!)
        } else if gesture.didTapAttributedTextInLabel(label: policiesLabel, inRange: privacyRange){
            openURL(url: URL(string: Constants.privacyPolicyURL)!)
        }
    }
    
    @IBAction func policyCheck(_ sender: UIButton) {
        if sender.backgroundColor == .white{
            privayChecked = true
            privacyButton.layer.borderWidth = 0
            privacyButton.backgroundColor = #colorLiteral(red: 0, green: 0.4764692187, blue: 1, alpha: 1)
            buttonCheck()
        }else{
            privayChecked = false
            privacyButton.layer.borderWidth = 2
            privacyButton.backgroundColor = .white
            buttonCheck()
        }
    }
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardtop = view.frame.size.height - keyboardFrame.cgRectValue.height
            if keyboardtop < textFieldAmount ?? 1.0{
                viewTop.constant = keyboardtop - textFieldAmount!
                UIView.animate(withDuration: 0.25) {self.view.layoutSubviews()
                }
            }
        }
    }
    func addLoading(){
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
    }
    @IBAction func login(_ sender: Any) {
        addLoading()
        policiesLabel.isUserInteractionEnabled = false
        if ConnectivityManager.checkNetworkStatus == true{
            LoginModel.shared.loginCheck(emailLogin: true, email: userString.text!, name: "-", password: Helpers.shared.codeString())
        }
    }
    func buttonCheck(){
        if userString.text != "" && emailPred.evaluate(with: userString.text!) == true && privayChecked == true{
            loginButton.isUserInteractionEnabled = true
            loginButton.layer.opacity = 1
        }else{
            loginButton.isUserInteractionEnabled = false
            loginButton.layer.opacity = 0.6
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

extension LoginViewController:LoginVCDelegate,UITextFieldDelegate{
    
    func removeLoading(){
        policiesLabel.isUserInteractionEnabled = true
        LoadingAnimationView.shared.removeFromSuperview()
    }
    func loginError(){
        present(AlertView.shared.returnLinkAlert(), animated: true)
    }
    func segueToLanguages(email:String,password:String,name:String){
        self.name = name
        self.password = password
        self.email = email
        self.performSegue(withIdentifier: "languages", sender: self)
    }
    
    func login(email:String, name:String, password :String){
        LoginModel.shared.login(email: email, name: name, password: password, auto: false, homeRefresh: false, language: "nil") { value in
            if value == true{
                PhraseData.shared.retrieveDailyPhrase()
                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainController") as! UITabBarController
                    NetworkModel.shared.retrieveProPractice()
                    self.view.window?.rootViewController = mainViewController
            }else{
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    func returnLoginResult(result:Bool){
        policiesLabel.isUserInteractionEnabled = true
        if result == true{
        present(AlertView.shared.returnEmailLogin(), animated: true) 
        }else{
        present(AlertView.shared.returnEmailErrorAlert(), animated: true)
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        buttonCheck()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userString{
            emailWarning.text = ""
            usernameView.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            textFieldAmount = usernameView.frame.maxY + 16
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason){
        viewTop.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutSubviews()
        }
        if emailPred.evaluate(with: userString.text!) == false  && userString.text != ""{
            usernameView.layer.borderColor = #colorLiteral(red: 0.628931284, green: 0.04916673899, blue: 0, alpha: 1)
            emailWarning.text = "Please enter a valid email address"
        }else{
            usernameView.layer.borderColor = #colorLiteral(red: 0.8469871879, green: 0.8471065164, blue: 0.8469495177, alpha: 1)
        }
    }
}
