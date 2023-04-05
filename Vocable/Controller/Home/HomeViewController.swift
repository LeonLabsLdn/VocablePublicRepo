import Foundation
import AVFAudio
import UIKit
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds

class HomeViewController: UIViewController{
    
    var bannerView                          = GADBannerView(adSize: GADAdSizeBanner)
    let homeQuizCollectionView              = HomeQuizCollectionView()
    @IBOutlet weak var rightBarView         : LivesBarView!
    @IBOutlet weak var leftBarView          : XPBarView!
    @IBOutlet weak var homeProView          : HomeProView!
    @IBOutlet weak var homeDataView         : HomeDataView!
    @IBOutlet weak var cardView             : SharedCardView!
    @IBOutlet weak var homeDataViewHeight   : NSLayoutConstraint!
    @IBOutlet weak var homeProViewHeight    : NSLayoutConstraint!
    @IBOutlet weak var homeDataViewTop      : NSLayoutConstraint!
    @IBOutlet weak var contentView          : UIView!
    @IBOutlet weak var quizView             : UIView!
    @IBOutlet weak var streakView           : UIView!
    @IBOutlet weak var scrollView           : UIScrollView!
    var selected                            : String?
    @IBOutlet weak var scrollViewBottom     : NSLayoutConstraint!
    @IBOutlet weak var dailyLabel           : UILabel!
    @IBOutlet weak var practiceLabel        : UILabel!
    
    override func viewDidLoad() {
        if PurchaseModel.shared.isPro != true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.homeProView.closeButtonFunc(self)
            }
        }
        requestIDFA()
        scrollView.delegate = self
        PurchaseModel.shared.fetchProducts()
        cardView.addButton.isHidden = true
        cardView.addBottom.constant = 0
        cardView.addHeight.constant = 0
        cardView.faveButton.isHidden = true
        Protocols.homeDelegate = self
        streakView.addSubview(HomeStreakCollectionView.shared)
        quizView.addSubview(homeQuizCollectionView)
        homeQuizCollectionView.frame = CGRect(x: 0, y: 8, width: view.frame.size.width, height: 186)
        cardView.faveButton.addTarget(self, action: #selector(faveButton(_:)), for: .touchUpInside)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(statsViewFunc(sender:)))
        homeDataView.streakView.addGestureRecognizer(tapGesture1)
        homeDataView.streakButton.addTarget(self, action: #selector(statsViewFunc(sender:)), for: .touchUpInside)
        if ConnectivityManager.checkNetworkStatus != true{present(AlertView.shared.offlineAlert(), animated: true)}
        homeProView.goProButton.addTarget(self, action: #selector(goProButton(sender:)), for: .touchUpInside)
        
    }
    
    func requestIDFA() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
    }
    
    @objc func segueToPractice(sender:Any){
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            UserData.listSegue = true
            tabBarController!.selectedIndex = 2
        }
    }
    
    @objc func proViewFunc(sender:Any){
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            if PurchaseModel.shared.isPro != true{
                performSegue(withIdentifier: "pro", sender: self)
            }
        }
    }
    
    @objc func statsViewFunc(sender:Any){
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            performSegue(withIdentifier: "statsView", sender: self)
        }
    }
    
    @objc func buyLivesViewFunc(sender:Any){
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            performSegue(withIdentifier: "buyLives", sender: self)
        }
    }
    
    @objc func profileViewFunc(sender:Any){
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            tabBarController!.selectedIndex = 4
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dailyLabel.text = "Your daily \(UserData.lang)"
        practiceLabel.text = "Practice your \(UserData.lang)"
        leftBarView.icon.image = UIImage(named: UserData.lang)
        cardView.learningIcon.image = UIImage(named: UserData.lang)
        cardView.learningExampleIcon.image = UIImage(named: UserData.lang)
        
        
        
        tabBarController!.tabBar.layer.borderWidth = 0.0
        tabBarController!.tabBar.layer.borderColor = nil
        tabBarController?.tabBar.clipsToBounds = false
        tabBarController?.tabBar.scrollEdgeAppearance = nil
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        navigationController!.tabBarItem.image = UIImage(systemName: "house.fill")
        if ConnectivityManager.checkNetworkStatus == false{
            LoadingAnimationView.shared.center = self.view.center
            self.view.addSubview(LoadingAnimationView.shared)
            navigationController?.tabBarController?.tabBar.isUserInteractionEnabled = false
            present(AlertView.shared.offlineAlert(), animated: true, completion: nil)
        }
        setData()
    }
    
    
    
    @objc func faveButton(_:Any){
        if ConnectivityManager.checkNetworkStatus == true{
            Helpers.shared.impactFeedbackGenerator.medium.prepare()
            Helpers.shared.impactFeedbackGenerator.medium.impactOccurred()
            cardView.spinner.isHidden = false
            cardView.faveButton.isHidden = true
            UserData.isLoading.append("\(UserDefaults.standard.string(forKey: "dTableNo")!),\(UserDefaults.standard.string(forKey: "dCatNo")!),\(UserDefaults.standard.string(forKey: "dID")!)")
            Protocols.phraseDelegate?.checkPhraseRow()
            NetworkModel.shared.updateFave(table: UserDefaults.standard.string(forKey: "dTableNo")!, row: UserDefaults.standard.string(forKey: "dID")!, sub: UserDefaults.standard.string(forKey: "dCatNo")!)
        }else{
            present(AlertView.shared.offlineAlert(), animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool){
        bannerView.removeFromSuperview()
        navigationController!.tabBarItem.image = UIImage(systemName: "house")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let practice = segue.destination as? QuizControllerViewController
        if segue.identifier == "quickPractice" {
            practice!.category = selected!
        }
    }
    
    func setData(){
        getStarStatus()
        let buyLivesGesture             = UITapGestureRecognizer(target: self, action: #selector(buyLivesViewFunc(sender:)))
        let proViewGesture              = UITapGestureRecognizer(target: self, action: #selector(proViewFunc(sender:)))
        let practiceSegueGesture        = UITapGestureRecognizer(target: self, action: #selector(segueToPractice(sender:)))
        let profileSegueGesture         = UITapGestureRecognizer(target: self, action: #selector(profileViewFunc(sender:)))
        homeProView.monthLabel.text     = UserDefaults.standard.string(forKey: "monthPrice")
        homeProView.yearLabel.text      = UserDefaults.standard.string(forKey: "3monthPrice")
        cardView.engLabel.text          = UserDefaults.standard.string(forKey: "dEnglish")
        cardView.itaLabel.text          = UserDefaults.standard.string(forKey: "translation")
        cardView.pronounceLabel.text    = UserDefaults.standard.string(forKey: "dPronounciation")
        cardView.exampleLabel.text      = UserDefaults.standard.string(forKey: "dEngExample")
        cardView.itaExample.text        = UserDefaults.standard.string(forKey: "dItaExample")
        if cardView.pronounceLabel.text == ""{
            cardView.pronounceHeight.constant = 0
            cardView.pronounceBottom.constant = 3
            cardView.cardHeight.constant = 82.33
        }else{
            cardView.pronounceHeight.constant = 19
            cardView.pronounceBottom.constant = 11
            cardView.cardHeight.constant = 109.33
        }
        leftBarView.xpLabel.text        = "\(UserStats.xp)XP"
        homeDataView.fireLabel.text     = "\(UserStats.streakCount) Day Streak"
        HomeStreakCollectionView.shared.collectionView?.reloadData()
        homeDataView.livesButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        homeDataView.masteredButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        homeDataView.masteredButton.tintColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        homeDataView.livesButton.tintColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        homeDataView.masteredButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        homeDataView.livesButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        if PurchaseModel.shared.isPro == true{
            bannerView.removeFromSuperview()
            scrollViewBottom.constant = 0
            homeProViewHeight.constant = 0
            homeProView.isHidden = true
            contentView.layoutSubviews()
            homeDataView.lifeLabel.text = "∞ Lives"
            rightBarView.livesLabel.text = "∞"
            homeDataView.setMasteredLabel()
            homeDataView.proStatsViewHeight.constant = 159
            if UserStats.stats.count != 0 && UserStats.stats[0] < 1{
                homeDataView.reminderMainView.isHidden = false
                homeDataView.proStatsView.isHidden = false
                homeDataView.practiceView.isHidden = true
                homeDataViewHeight.constant = 547
                homeDataView.practiceViewHeight.constant = 0
            }else{
                homeDataView.practiceView.isHidden = false
                homeDataView.reminderMainView.isHidden = true
                homeDataView.proStatsView.isHidden = false
                homeDataView.practiceViewHeight.constant = 62
                homeDataViewHeight.constant = 430
            }
            homeDataView.proStatsView.isHidden = false
            homeDataView.livesButton.setTitle("Profile", for: .normal)
            homeDataView.masteredButton.setTitle("Practice", for: .normal)
            homeDataView.proView.removeGestureRecognizer(proViewGesture)
            homeDataView.lifeView.removeGestureRecognizer(buyLivesGesture)
            homeDataView.livesButton.removeTarget(self, action: #selector(buyLivesViewFunc(sender:)), for: .allEvents)
            homeDataView.masteredButton.removeTarget(self, action: #selector(proViewFunc(sender:)), for: .allEvents)
            homeDataView.proView.addGestureRecognizer(practiceSegueGesture)
            homeDataView.lifeView.addGestureRecognizer(profileSegueGesture)
            homeDataView.masteredButton.addTarget(self, action: #selector(segueToPractice(sender:)), for: .touchUpInside)
            homeDataView.livesButton.addTarget(self, action: #selector(profileViewFunc(sender:)), for: .touchUpInside)
            if ConnectivityManager.checkNetworkStatus == true{
                homeDataView.dailyQuizCount.text = String(describing: UserStats.stats[0])
                homeDataView.dailyMasteredCount.text = String(describing: UserStats.stats[2])
            }
        }else{
            if bannerView.isDescendant(of: view) == false{
                bannerView.adUnitID = "ca-app-pub-1067528508711342/1543082113"
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
                addBannerViewToView(bannerView)
            }
            scrollViewBottom.constant = 66
            homeDataView.livesButton.setTitle("Get lives", for: .normal)
            homeDataView.masteredButton.setTitle("Go pro", for: .normal)
            homeDataView.lifeView.removeGestureRecognizer(profileSegueGesture)
            homeDataView.proView.removeGestureRecognizer(practiceSegueGesture)
            homeDataView.livesButton.removeTarget(self, action: #selector(profileViewFunc(sender:)), for: .allEvents)
            homeDataView.masteredButton.removeTarget(self, action: #selector(segueToPractice(sender:)), for: .allEvents)
            homeDataView.lifeView.addGestureRecognizer(buyLivesGesture)
            homeDataView.proView.addGestureRecognizer(proViewGesture)
            homeDataView.livesButton.addTarget(self, action:#selector(buyLivesViewFunc(sender:)), for: .touchUpInside)
            homeDataView.masteredButton.addTarget(self, action: #selector(proViewFunc(sender:)), for: .touchUpInside)
            homeDataView.proStatsViewHeight.constant = 0
            homeDataView.proStatsView.isHidden = true
            if UserStats.stats.count != 0 && UserStats.stats[0] < 1{
                homeDataView.reminderMainView.isHidden = false
                homeDataView.practiceView.isHidden = true
                homeDataViewHeight.constant = 388
                homeDataView.practiceViewHeight.constant = 0
            }else{
                homeDataView.practiceView.isHidden = false
                homeDataView.reminderMainView.isHidden = true
                homeDataViewHeight.constant = 271
                homeDataView.practiceViewHeight.constant = 62
            }
            if UserStats.lives == 1{
                homeDataView.lifeLabel.text = "\(UserStats.lives) Life Left"
            }else{
                if homeProView.closeButton.imageView?.image == UIImage(systemName: "xmark"){
                    homeProViewHeight.constant = 162
                }else{
                    homeProViewHeight.constant = 56
                }
                homeProView.isHidden = false
                contentView.layoutSubviews()
                homeDataView.lifeLabel.text = "\(UserStats.lives) Lives Left"}
            rightBarView.livesLabel.text = "\(UserStats.lives)"
        }
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .bottom,multiplier: 1,constant: -8),
         NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
     }
    func getStarStatus(){
        NetworkModel.shared.checkFavouriteStatus(table: UserDefaults.standard.string(forKey: "dTableNo") ?? "", row: UserDefaults.standard.string(forKey: "dID") ?? "", sub: UserDefaults.standard.string(forKey: "dCatNo") ?? "", completion: { [self] star in
            cardView.faveButton.setImage(UIImage(systemName: "\(star)"), for: .normal)
            DispatchQueue.main.async {
                self.cardView.spinner.isHidden = true
                self.cardView.faveButton.isHidden = false}
        })
    }
    @objc func goProButton(sender:UIButton) {
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            performSegue(withIdentifier: "pro", sender: self)}}
}

extension HomeViewController:HomeDelegate,UIScrollViewDelegate{
    
    func faveLoading(){
        cardView.faveButton.isHidden = true
        cardView.spinner.isHidden = false
    }
    func updateFave(result:String){
        cardView.faveButton.setImage(UIImage(systemName: result), for: .normal)
        cardView.faveButton.isHidden = false
        cardView.spinner.isHidden = true
    }
    func refreshContent(){
        contentView.layoutSubviews()
        scrollView.layoutSubviews()
    }
    func homeContentHeight(amount:CGFloat) {
        homeProViewHeight.constant = amount;print("\(amount)")
    }
    func homeLayoutSubview() {
        contentView.layoutSubviews()
    }
    func updateHomeQuiz(){
        homeQuizCollectionView.collectionView?.reloadData()
    }
    func updateDaily() {
        setData()
    }
    func homeLogout(){
        UserDefaults.standard.setValue(true, forKey: "updated")
        UserDefaults.standard.setValue("", forKey: "gpic")
        performSegue(withIdentifier: "logout", sender: self)
    }
    func homeLogin(){
        LoadingAnimationView.shared.removeFromSuperview()
        navigationController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        NetworkModel.shared.updateUserData { _ in }
        homeQuizCollectionView.collectionView?.reloadData()
        setData()
        getStarStatus()
        Protocols.profileDelegate?.offlineReload()
        PurchaseModel.shared.fetchProducts()
    }
    func resetUserData() {
        if UserData.offline != true{
            do{
                let result = try Keychain.shared.search()
                LoginModel.shared.login(email: result["username"]!, name: "-", password: result["password"]!,auto: true, homeRefresh:true, language: "nil"){ value in
                }
            }catch{
                do{
                    try Keychain.shared.delete()
                    homeLogout()
                }catch{
                    homeLogout()
                }
            }
        }else{
            print("offline")
        }
    }
    func setDataFunc(){
        setData()
    }

    func proState(){
        if PurchaseModel.shared.isPro == true || PurchaseModel.shared.proCount == PurchaseModel.shared.products?.count{
            self.setData()
            PurchaseModel.shared.proCount = 0
        }else{
            PurchaseModel.shared.purchaseState(product: PurchaseModel.shared.products![PurchaseModel.shared.proCount])
        }
    }
    
    func startQuiz(cat: String) {
        if ConnectivityManager.checkNetworkStatus == true{
            if PurchaseModel.shared.isPro == true || UserStats.lives != 0{
                selected = cat
                self.performSegue(withIdentifier: "quickPractice", sender: self)
            }else{
                self.performSegue(withIdentifier: "noLives", sender: self)
            }
        }else{
            present(AlertView.shared.offlineAlert(),animated: true)
        }
    }
    func setPrice(){
        DispatchQueue.main.async {
            self.homeProView.monthLabel.text = UserDefaults.standard.string(forKey: "monthPrice")
            self.homeProView.yearLabel.text = UserDefaults.standard.string(forKey: "3monthPrice")
        }
    }
}


