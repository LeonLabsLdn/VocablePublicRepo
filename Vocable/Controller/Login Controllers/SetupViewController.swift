import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var labelLeft: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var languageImage: UIImageView!
    let languageView = ChangeLanguageView()
    let loading = LoadingAnimationView()
    var email:String?
    var name:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = continueButton.frame.size.height / 2
        selectionView.layer.cornerRadius = selectionView.frame.size.height / 2
        selectionView.layer.borderWidth = 1
        selectionView.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showLanguages(sender:)))
        selectionView.addGestureRecognizer(tap)
        languageView.closeButton.isHidden = true
        let italian = UITapGestureRecognizer(target: self, action: #selector(selectLanguage(sender:)));italian.name = "Italian"
        let spanish = UITapGestureRecognizer(target: self, action: #selector(selectLanguage(sender:)));spanish.name = "Spanish"
        let french = UITapGestureRecognizer(target: self, action: #selector(selectLanguage(sender:)));french.name = "French"
        let german = UITapGestureRecognizer(target: self, action: #selector(selectLanguage(sender:)));german.name = "German"
        languageView.italianView.addGestureRecognizer(italian)
        languageView.spanishView.addGestureRecognizer(spanish)
        languageView.frenchView.addGestureRecognizer(french)
        languageView.germanView.addGestureRecognizer(german)
        continueButton.isUserInteractionEnabled = false
    }
    
    @objc func showLanguages(sender:Any){
        self.navigationItem.setHidesBackButton(true, animated: false)
        languageView.italianXP.isHidden = true
        languageView.spanishXP.isHidden = true
        languageView.germanXP.isHidden = true
        languageView.frenchXP.isHidden = true
        view.addSubview(languageView)
        languageView.frame = view.frame
    }
    
    @objc func selectLanguage(sender:UITapGestureRecognizer){
        self.navigationItem.setHidesBackButton(false, animated: false)
        languageImage.image = UIImage(named: sender.name!)
        label.text = sender.name
        labelLeft.constant = 11
        imageWidth.constant = 28
        continueButton.isUserInteractionEnabled = true
        continueButton.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        languageView.removeFromSuperview()
    }
    

    @IBAction func login(_ sender: Any) {
        view.addSubview(loading)
        loading.center = view.center
        loading.animationView?.play()
        print(label.text!)
        LoginModel.shared.login(email: email!, name: name!, password: password!, auto: false, homeRefresh: false, language: label.text!){ [self] value in
            if value == true{
            do{
                try Keychain.shared.addcreds(username: email!, password: password!)
                DispatchQueue.main.async {
                    PhraseData.shared.retrieveDailyPhrase()
                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainController") as! UITabBarController
                    NetworkModel.shared.retrieveProPractice()
                    self.view.window?.rootViewController = mainViewController
                    self.loading.removeFromSuperview()
                }
            }catch{
                loading.removeFromSuperview()
            }
            }else{
                loading.removeFromSuperview()
            }
        }
    }
}
