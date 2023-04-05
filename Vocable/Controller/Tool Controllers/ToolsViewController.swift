import UIKit
import GoogleMobileAds

class ToolsViewController: UIViewController {
    
    @IBOutlet weak var translateView    : UIView!
    @IBOutlet weak var leftBarView      : XPBarView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var livesView: LivesBarView!
    
    var bannerView                          = GADBannerView(adSize: GADAdSizeBanner)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let i = [translateView,scanView]
        for i in i{
            i?.layer.shadowColor = UIColor.gray.cgColor
            i?.layer.shadowOpacity = 0.15
            i?.layer.cornerRadius = 10
            i?.layer.shadowRadius = 10
            i?.layer.shadowOffset = CGSize(width: 0, height: 1)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(translateSegue(_:)))
        translateView.addGestureRecognizer(tapGesture)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(objectSegue(_:)))
        scanView.addGestureRecognizer(tapGesture1)
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .bottom,multiplier: 1,constant: -8),
         NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
     }
    
    @objc func translateSegue(_:Any){
        self.performSegue(withIdentifier: "translator", sender: self)
    }
    @objc func objectSegue(_:Any){
        self.performSegue(withIdentifier: "objects", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leftBarView.icon.image = UIImage(named: UserData.lang)
        if PurchaseModel.shared.isPro == true{
            livesView.livesLabel.text = "∞"
            bannerView.removeFromSuperview()
        }else{
            livesView.livesLabel.text = "\(UserStats.lives)"
            if bannerView.isDescendant(of: view) == false{
                bannerView.adUnitID = "ca-app-pub-1067528508711342/1388536423"
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
                addBannerViewToView(bannerView)
            }
        }
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBarController?.tabBar.standardAppearance = appearance
            tabBarController?.tabBar.scrollEdgeAppearance = nil
            self.tabBarController!.tabBar.layer.borderWidth = 0.50
            self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
            self.tabBarController?.tabBar.clipsToBounds = true
        }
        leftBarView.xpLabel.text = "\(UserStats.xp)XP"
        navigationController!.tabBarItem.image = UIImage(systemName: "paperplane.fill")
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.tabBarItem.image = UIImage(systemName: "paperplane")
    }
}
