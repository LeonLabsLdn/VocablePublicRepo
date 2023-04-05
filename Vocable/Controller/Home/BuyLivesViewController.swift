import GoogleMobileAds
import UIKit

class BuyLivesViewController: UIViewController{
    
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var freeLifeView: UIView!
    @IBOutlet weak var proCardView: HomeProView!
    @IBOutlet weak var watchAdButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var xpCount: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var closeButton: UIView!
    private var rewardedAd: GADRewardedAd?
    @IBOutlet weak var livesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livesCheck()
        xpCount.text = String(describing: UserStats.xp)
        exchangeView.layer.cornerRadius = 10
        freeLifeView.layer.cornerRadius = 10
        proCardView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.size.height / 2
        watchAdButton.layer.cornerRadius = watchAdButton.frame.size.height / 2
        watchAdButton.layer.borderWidth = 2
        watchAdButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
        closeButton.addGestureRecognizer(tap)
        livesLabel.text = "\(UserStats.lives)/5"
        proCardView.closeButton.isHidden = true
        proCardView.goProButton.addTarget(self, action: #selector(goPro(Sender:)), for: .touchUpInside)
        proCardView.monthLabel.text = UserDefaults.standard.string(forKey: "monthPrice")
        proCardView.yearLabel.text = UserDefaults.standard.string(forKey: "3monthPrice")
    }
    
    @objc func goPro(Sender:UIButton){
       performSegue(withIdentifier: "pro", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PurchaseModel.shared.isPro == true{
            Protocols.homeDelegate?.updateDaily()
            dismiss(animated: true)
            
        }
    }
    
    @IBAction func watchAd(_ sender: Any) {
        if UserStats.lives == 5{
            present(AlertView.shared.returnMaxLivesAlert(), animated: true)
        }else{
            view.isUserInteractionEnabled = false
            LoadingAnimationView.shared.center = view.center
            view.addSubview(LoadingAnimationView.shared)
            loadRewardedAd()
        }
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-1067528508711342/2413249613", request: request, completionHandler: { [self] ad, error in
            if let error = error {
                LoadingAnimationView.shared.removeFromSuperview()
                view.isUserInteractionEnabled = true
                present(AlertView.shared.returnNoAdAlert(), animated: true)
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            if let ad = rewardedAd {
                ad.present(fromRootViewController: self) {
                    self.view.isUserInteractionEnabled = true
                    UserStats.lives = UserStats.lives + 1
                    NetworkModel.shared.updateUserData { value in
                        if value != true{
                            UserStats.lives = UserStats.lives - 1
                        }
                        LoadingAnimationView.shared.removeFromSuperview()
                        self.livesLabel.text = "\(UserStats.lives)/5"
                        Protocols.homeDelegate?.setDataFunc()
                    }
                }
            }else{
                view.isUserInteractionEnabled = true
                present(AlertView.shared.returnNoAdAlert(), animated: true)
                LoadingAnimationView.shared.removeFromSuperview()
                print("Ad wasn't ready")
            }
            print("Rewarded ad loaded.")
        }
        )
    }
    
    @objc func close(sender:UITapGestureRecognizer){
        dismiss(animated: true)
    }
    
    func livesCheck(){
        if UserStats.lives + Int(slider.value) > 5{
            confirmButton.isUserInteractionEnabled = false
            confirmButton.backgroundColor = .gray
        }else{
            confirmButton.isUserInteractionEnabled = true
            confirmButton.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        }
    }
    
    @IBAction func sliderFunction(_ sender: Any) {
        let value = String(Int(slider.value))
        amountLabel.text = "\(value) for \(200 * Int(slider.value))XP"
livesCheck()
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        if UserStats.stats[6] == 5 {
            present(AlertView.shared.returnExchangeLimitAlert(), animated: true, completion: nil)
        }else if UserStats.xp < 200 * Int(slider.value){
            present(AlertView.shared.returnInsufficientXPAlert(), animated: true, completion: nil)
        }else{
            LoadingAnimationView.shared.center = view.center
            view.addSubview(LoadingAnimationView.shared)
            slider.isUserInteractionEnabled = false
            UserStats.lives = UserStats.lives + Int(slider.value)
            UserStats.xp = UserStats.xp - 200 * Int(slider.value)
            UserStats.stats[6] = UserStats.stats[6] + Int(slider.value)
            NetworkModel.shared.updateUserData { result in
                if result == false{
                    UserStats.lives = UserStats.lives - Int(self.slider.value)
                    UserStats.xp = UserStats.xp + 200 * Int(self.slider.value)
                    UserStats.stats[6] = UserStats.stats[6] - Int(self.slider.value)
                    self.present(AlertView.shared.returnErrorAlert(),animated: true)
                }else{
                    self.xpCount.text = String(describing: UserStats.xp)
                    self.livesLabel.text = "\(UserStats.lives)/5"
                    Protocols.homeDelegate?.setDataFunc()
                    self.present(AlertView.shared.returnLivesSuccessAlert(),animated: true)
                }
                LoadingAnimationView.shared.removeFromSuperview()
                self.slider.isUserInteractionEnabled = true
            }
        }
        
    }
    
    
}
