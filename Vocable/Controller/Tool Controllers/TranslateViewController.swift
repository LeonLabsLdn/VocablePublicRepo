import UIKit
import GoogleMobileAds

class TranslateViewController: UIViewController{
    
    @IBOutlet weak var resultTextView   : UITextView!
    @IBOutlet weak var recordImage      : UIImageView!
    @IBOutlet weak var langViewOne      : UIView!
    @IBOutlet weak var langViewTwo      : UIView!
    @IBOutlet weak var reverseView      : UIView!
    @IBOutlet weak var textView         : UITextView!
    @IBOutlet weak var textViewHeight   : NSLayoutConstraint!
    @IBOutlet weak var line             : UIView!
    @IBOutlet weak var itTranLabel      : UILabel!
    @IBOutlet weak var recordView       : UIView!
    @IBOutlet weak var recordingLabel   : UILabel!
    @IBOutlet weak var fromLanguage     : UILabel!
    @IBOutlet weak var toLanguage       : UILabel!
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var resultHeight     : NSLayoutConstraint!
    @IBOutlet weak var resultView       : UITextView!
    var eng                             = true
    var bannerView                      = GADBannerView(adSize: GADAdSizeBanner)
    
    @IBOutlet weak var languageTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toLanguage.text = UserData.lang
        itTranLabel.text = "Translation"
        Protocols.translateDelegate = self
        self.textViewHeight.constant = self.view.frame.height
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: { (action) -> Void in})
        let settings = UIAlertAction(title: "settings", style: .default, handler: { (action) -> Void in
            self.goToAppSettings()
        })
        AlertView.shared.updateAccesibility.addAction(cancel)
        AlertView.shared.updateAccesibility.addAction(settings)
        recordView.layer.shadowColor = #colorLiteral(red: 0.8248381019, green: 0.540815413, blue: 0.5206935406, alpha: 1)
        recordView.layer.shadowOpacity = 0
        recordView.layer.shadowRadius = 18
        self.dismissKeyboard()
        let langViews = [langViewOne,langViewTwo]
        for langView in langViews{
            langView?.layer.shadowColor = UIColor.gray.cgColor
            langView?.layer.shadowOpacity = 0.2
            langView?.layer.cornerRadius = 10
            langView?.layer.shadowRadius = 10
        }
        reverseView.layer.cornerRadius = 10
        resultHeight.constant = containerView.frame.height / 2 - 32
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(reverse(_:)))
        reverseView.addGestureRecognizer(tapGesture1)
        line.layer.opacity = 0
        itTranLabel.layer.opacity = 0
        line.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        line.layer.borderWidth = 10
        recordView.layer.cornerRadius = recordView.frame.size.height / 2
        textView.textColor = UIColor.lightGray
        if UserDefaults.standard.bool(forKey: UserData.lang) != true{
            present(AlertView.shared.modelDownloading(), animated: true, completion: nil)
        }
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,attribute: .top,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .top,multiplier: 1,constant: 8),
         NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
     }
    @objc func reverse(_:Any){
        if fromLanguage.text == UserData.lang{
            fromLanguage.text = "English"
            toLanguage.text = UserData.lang
            eng = true
        }else{
            fromLanguage.text = UserData.lang
            toLanguage.text = "English"
            eng = false
        }
        if fromLanguage.text == "English"{
            TranslateModel.shared.translate(eng:textView.text, learningLang:"")
        }else{
            TranslateModel.shared.translate(eng:"", learningLang:textView.text)
        }
    }
    func goToAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @objc func authFailed(_:Any){
        self.present(AlertView.shared.updateAccesibility, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        AudioModel.shared.checkRecordingPermission()
        navigationController!.tabBarItem.image = UIImage(systemName: "paperplane.fill")
        if PurchaseModel.shared.isPro == true{
        bannerView.removeFromSuperview()
           languageTop.constant = 16
        }else if bannerView.isDescendant(of: view) == false{
            languageTop.constant = 82
                bannerView.adUnitID = "ca-app-pub-1067528508711342/9185156031"
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
                addBannerViewToView(bannerView)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        navigationController!.tabBarItem.image = UIImage(systemName: "paperplane")
    }
    @objc func recordTapped(gestureReconizer: UITapGestureRecognizer) {
        if recordingLabel.text != "Recording..." {
            line.layer.opacity = 0
            resultView.text = ""
            textView.text = ""
            itTranLabel.layer.opacity = 0
            recordView.backgroundColor = .red
            recordImage.image = UIImage(systemName: "stop.fill")
            recordingLabel.text = "Recording..."
            UIView.animate(withDuration: 0.5) { [self] in
                recordView.layer.shadowOpacity = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
                    UIView.animate(withDuration: 0.8) { [self] in
                        recordView.layer.shadowOpacity = 0
                    }
                }
            }
            DispatchQueue.main.async {
                do {
                    try AudioModel.shared.startRecording(eng: self.eng)
                } catch {
                    print("error")
                }
            }
        }else{
            AudioModel.shared.stop()
        }
    }
    func translate(){
        print("translating")
        if fromLanguage.text == "English"{
            
            TranslateModel.shared.translate(eng:textView.text, learningLang:"")
        }else{
            TranslateModel.shared.translate(eng:"", learningLang:textView.text)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            line.layer.opacity = 1
            itTranLabel.layer.opacity = 1
            textView.resignFirstResponder()
            translate()
            return false
        }
        return true
    }
    func updateTextView(){
        let sizeToFitIn = CGSize(width: self.textView.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newSize = self.textView.sizeThatFits(sizeToFitIn)
        if newSize.height >= containerView.frame.height / 2{
            self.textViewHeight.constant = containerView.frame.height / 2 - 32
        }else{
            resultHeight.constant = containerView.frame.height / 2
            self.textViewHeight.constant = newSize.height
        }
    }
}

//------------------------------------------------------------------------

extension TranslateViewController:TranslateDelegate,UITextViewDelegate{
    func completeTranslate() {
        resultView.text = TranslateModel.shared.translation
        if UserDefaults.standard.bool(forKey: "playAudio") == true{
            UserDefaults.standard.setValue(false, forKey: "playAudio")
            if fromLanguage.text == UserData.lang{
                UserDefaults.standard.setValue(true, forKey: "tran")
            }
            Helpers.shared.speak(phrase: resultView.text!)
        }
    }
    func popToRoot(){
        navigationController?.popToRootViewController(animated: false)
    }
    func endTranscribe(){
        recordingLabel.text = ""
        recordImage.image = UIImage(systemName: "mic.fill")
        recordView.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        textView.textColor = .black
        UserDefaults.standard.setValue(true, forKey: "playAudio")
        self.translate()
    }
    func updateLabel(text:String){
        self.textView.textColor = .black
        self.textView.text = text
        self.updateTextView()
        self.line.layer.opacity = 1
        self.itTranLabel.layer.opacity = 1
    }
    func authorisationFailed(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authFailed(_:)))
        recordView.addGestureRecognizer(tapGesture)
    }
    func authorisationSuccess(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recordTapped(gestureReconizer:)))
        recordView.addGestureRecognizer(tapGesture)
    }
    func textViewDidChange(_ textView: UITextView) {
        updateTextView()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            self.textViewHeight.constant = self.view.frame.height
            textView.text = "Enter text..."
            textView.textColor = #colorLiteral(red: 0.5764203668, green: 0.5765039325, blue: 0.5763940215, alpha: 1)
        }
    }
    func dismiss(){
        navigationController?.popToRootViewController(animated: true)
    }
    func textViewDidBeginEditing (_ textView: UITextView) {
        updateTextView()
        line.layer.opacity = 0
        resultView.text = ""
        itTranLabel.layer.opacity = 0
        if textView.text == "Enter text..."{
            textView.text = ""
            textView.textColor = .black
        }
    }
}
