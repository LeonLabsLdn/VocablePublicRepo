import UIKit
import Foundation
import GoogleMobileAds

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var imageView            : UIImageView!
    @IBOutlet weak var nameLabel            : UILabel!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var masteredCard         : UIView!
    @IBOutlet weak var leftBarView          : XPBarView!
    @IBOutlet weak var progressBar          : UIProgressView!
    @IBOutlet weak var masteredLabel        : UILabel!
    @IBOutlet weak var percentageMastered   : UILabel!
    @IBOutlet weak var nameButton           : UIButton!
    @IBOutlet weak var icon                 : UIImageView!
    @IBOutlet weak var learningLabel        : UILabel!
    var bannerView                          = GADBannerView(adSize: GADAdSizeBanner)
    var vd                                  : Bool?
    @IBOutlet weak var changeLanguage       : UIButton!
    var end                                 : Bool?
    let languageView                        = ChangeLanguageView()
    let loading                             = LoadingAnimationView()
    
    @IBOutlet weak var profileBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage.layer.cornerRadius = changeLanguage.frame.size.height / 2
        changeLanguage.layer.borderWidth = 2
        changeLanguage.layer.borderColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
        nameButton.contentHorizontalAlignment = .right
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
        tableView.tableFooterView = footerView
        Protocols.profileDelegate = self
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
        masteredCard.layer.cornerRadius = 5
        navigationController?.setNavigationBarHidden(false, animated: true)
        imagePickerController.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfile(_:)), name: NSNotification.Name(rawValue: "setSettingsProfile"), object: nil)
        tableView.showsVerticalScrollIndicator = false
        setProfile(self)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        languageView.closeButton.addTarget(self, action: #selector(removeLanguageView(sender:)), for: .touchUpInside)
        let italian = UITapGestureRecognizer(target: self, action: #selector(updateLanguage(sender:)));italian.name = "Italian"
        let spanish = UITapGestureRecognizer(target: self, action: #selector(updateLanguage(sender:)));spanish.name = "Spanish"
        let french = UITapGestureRecognizer(target: self, action: #selector(updateLanguage(sender:)));french.name = "French"
        let german = UITapGestureRecognizer(target: self, action: #selector(updateLanguage(sender:)));german.name = "German"
        languageView.italianView.addGestureRecognizer(italian)
        languageView.spanishView.addGestureRecognizer(spanish)
        languageView.frenchView.addGestureRecognizer(french)
        languageView.germanView.addGestureRecognizer(german)
    }
    @objc func updateLanguage(sender:UITapGestureRecognizer){
        if UserData.lang == sender.name!{
            removeLanguageView(sender: self)
        }else{
            view.isUserInteractionEnabled = false
            navigationController?.navigationBar.isUserInteractionEnabled = false
            view.addSubview(loading)
            loading.animationView?.play()
            NetworkModel.shared.updateLanguage(language: sender.name!) { [self] value in
                leftBarView.icon.image = UIImage(named: UserData.lang)
                leftBarView.xpLabel.text = "\(UserStats.xp)XP"
                icon.image = UIImage(named: UserData.lang)
                learningLabel.text = "Learning \(UserData.lang)"
                view.isUserInteractionEnabled = true
                loading.removeFromSuperview()
                removeLanguageView(sender: self)
            }
        }
    }
    @IBAction func updateName(_ sender: Any) {
        present(AlertView.shared.returnUpdateNameForm(),animated: true)
    }
    @objc func setProfile(_: Any){
        nameLabel.text = UserData.name
        if ConnectivityManager.checkNetworkStatus == true{
            if UserDefaults.standard.string(forKey: "gpic") != nil{
                guard let url = URL(string: UserDefaults.standard.string(forKey: "gpic") ?? "") else { imageView.image = UIImage(named: "AppIcon");imageView.tintColor = .black;return }
                let data = try? Data(contentsOf: url)
                imageView.image = UIImage(data: data!)
            }else{
                imageView.image = UIImage(named: "AppIcon")
                imageView.tintColor = .black
            }
        }
    }
    
    
    
    @IBAction func changeLanguage(_ sender: Any) {
        navigationController?.navigationBar.isHidden = true
        leftBarView.isHidden = true
        bannerView.removeFromSuperview()
        languageView.frame =  view.frame
        languageView.languageView.isHidden = true
        view.addSubview(languageView)
        view.addSubview(loading)
        loading.center = view.center
        loading.animationView?.play()
        NetworkModel.shared.languageChange { [self] isTrue, data in
            loading.removeFromSuperview()
            if isTrue == false{
                removeLanguageView(sender: self)
            }else{
                languageView.italianXmark.isHidden = true
                languageView.spanishXmark.isHidden = true
                languageView.frenchXmark.isHidden = true
                languageView.germanXmark.isHidden = true
                switch UserData.lang{
                case "Italian":languageView.italianXmark.isHidden = false
                case "Spanish":languageView.spanishXmark.isHidden = false
                case "French":languageView.frenchXmark.isHidden = false
                default:languageView.germanXmark.isHidden = false
                }
                languageView.italianXP.text = "\(data["Italian"] ?? "0")xp"
                languageView.spanishXP.text = "\(data["Spanish"] ?? "0")xp"
                languageView.frenchXP.text = "\(data["French"] ?? "0")xp"
                languageView.germanXP.text = "\(data["German"] ?? "0")xp"
                
                languageView.languageView.isHidden = false
            }
        }
    }
    
    @objc func removeLanguageView(sender:Any){
        navigationController?.navigationBar.isHidden = false
        leftBarView.isHidden = false
        languageView.removeFromSuperview()
        if PurchaseModel.shared.isPro == true{
            bannerView.removeFromSuperview()
            profileBottom.constant = 0
        }else if bannerView.isDescendant(of: view) == false{
            bannerView.adUnitID = "ca-app-pub-1067528508711342/5073750121"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            addBannerViewToView(bannerView)
            profileBottom.constant = 66
        }
    }
    
    @IBAction func settingSegue(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        learningLabel.text = "Learning \(UserData.lang)"
        leftBarView.icon.image = UIImage(named: UserData.lang)
        icon.image = UIImage(named: UserData.lang)
        vd = true
        if end == true{
            if #available(iOS 15.0, *) {
                end = true
                tabBarController?.tabBar.scrollEdgeAppearance = nil
                self.tabBarController!.tabBar.layer.borderWidth = 0.50
                self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
                self.tabBarController?.tabBar.clipsToBounds = true
            }
        }else{
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                tabBarController?.tabBar.standardAppearance = appearance
                self.tabBarController!.tabBar.layer.borderWidth = 0.0
                self.tabBarController!.tabBar.layer.borderColor = nil
                self.tabBarController?.tabBar.clipsToBounds = false
                tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
            }
        }
        setStats()
        tableView.reloadData()
        leftBarView.xpLabel.text = "\(UserStats.xp)XP"
        navigationController!.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")
        if PurchaseModel.shared.isPro == true{
            bannerView.removeFromSuperview()
            profileBottom.constant = 0
        }else if bannerView.isDescendant(of: view) == false{
            bannerView.adUnitID = "ca-app-pub-1067528508711342/5073750121"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            addBannerViewToView(bannerView)
            profileBottom.constant = 66
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .bottom,multiplier: 1,constant: -8),
             NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.tabBarItem.image = UIImage(systemName: "person.crop.circle")
    }
    
    func setStats(){
        var amount = 0
        for v in UserData.masteredTables{amount = amount + DataModel.shared.proListDataQuery(value: "proEngArr", mastered:"1",tableNo: "\(v)").count
        }
        masteredLabel.text = "\(amount)/\(UserDefaults.standard.integer(forKey: "totalRows"))"
        let percent = Float(amount) / Float(UserDefaults.standard.integer(forKey: "totalRows")) * Float(100).rounded()
        var percentage = String()
        if "\(percent)" == "nan"{
            percentage = "-%"
        }else if percent < 1{
            percentage = "0%"
        }else{
            percentage = "\(Int(percent))%"
        }
        percentageMastered.text = percentage
        progressBar.progress = percent / 100
        if PurchaseModel.shared.isPro != true && amount != 0{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 72))
            let label = UILabel()
            let contentView = UIView()
            let proButon = UIButton()
            headerView.addSubview(contentView)
            contentView.addSubview(label)
            contentView.addSubview(proButon)
            proButon.frame = CGRect(x: tableView.frame.size.width - 104, y: 16, width: 88, height: 24)
            proButon.backgroundColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
            proButon.layer.cornerRadius = 12
            proButon.setImage(UIImage(systemName: "shield.fill"), for: .normal)
            proButon.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
            proButon.setTitle("Go pro", for: .normal)
            proButon.titleLabel?.textColor = .white
            proButon.imageView?.tintColor = #colorLiteral(red: 0.9261723161, green: 0.7164565921, blue: 0.2121852338, alpha: 1)
            proButon.imageView?.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
            proButon.imageEdgeInsets.right = 8
            contentView.frame = CGRect(x: 0, y: 8, width: tableView.frame.size.width, height: 56)
            proButon.addTarget(self, action: #selector(goPro(sender:)), for: .touchUpInside)
            label.frame = CGRect(x: 16, y: 0, width: 200, height: 56)
            label.text = "Continue where you left off"
            label.textColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
            label.font = UIFont(name: "Roboto-Bold", size: 16)
            contentView.layer.cornerRadius = 10
            contentView.backgroundColor = #colorLiteral(red: 0.7363070846, green: 0.8941474557, blue: 0.8019344211, alpha: 1)
            tableView.tableHeaderView = headerView
        }else{
            tableView.tableHeaderView = nil
        }
    }
    
    @objc func goPro(sender:UIButton){
        performSegue(withIdentifier: "pro", sender: self)
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource,ProfileDelegate{
    
    func updateStats() {
        setStats()
        tableView.reloadData()
    }
    
    func updateName(name:String){
        nameLabel.text = name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.catTotals.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height + 10;let contentYoffset = scrollView.contentOffset.y;let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {if #available(iOS 15.0, *) {
            end = true
            if vd != false{
                tabBarController?.tabBar.scrollEdgeAppearance = nil
                tabBarController!.tabBar.layer.borderWidth = 0.50
                tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor;tabBarController?.tabBar.clipsToBounds = true}}
        }else{
            if #available(iOS 15.0, *) {
                end = false
                if vd != false{
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = .white
                    tabBarController?.tabBar.standardAppearance = appearance
                    tabBarController!.tabBar.layer.borderWidth = 0.0;tabBarController!.tabBar.layer.borderColor = nil
                    tabBarController?.tabBar.clipsToBounds = false
                    tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance}}}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.barView.clipsToBounds = true
        cell.barView.layer.cornerRadius = 5
        cell.barView.subviews[1].clipsToBounds = true
        cell.barView.layer.sublayers![1].cornerRadius = 5
        cell.mainView.layer.cornerRadius = 10
        cell.masteredView.layer.cornerRadius = 5
        cell.progressView.layer.cornerRadius = 5
        cell.selectionStyle = .none
        if PurchaseModel.shared.isPro == true{
            cell.mainView.backgroundColor = #colorLiteral(red: 0.7363070846, green: 0.8941474557, blue: 0.8019344211, alpha: 1)
            cell.barView.progressTintColor = #colorLiteral(red: 0.3888377547, green: 0.5433984995, blue: 0.4553562999, alpha: 1)
            cell.percentageMasteredLabel.textColor = #colorLiteral(red: 0.3400390744, green: 0.5513827801, blue: 0.4479376078, alpha: 1)
            cell.wordsMasteredLabel.textColor = #colorLiteral(red: 0.3400390744, green: 0.5513827801, blue: 0.4479376078, alpha: 1)
            cell.titleLabel.textColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
            cell.progressTitleLabel.textColor = .black
            cell.masteredTitleLabel.textColor = .black
            cell.iconImage.layer.opacity = 1
        }else{
            cell.mainView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
            cell.barView.progressTintColor = #colorLiteral(red: 0.7439648509, green: 0.7726604342, blue: 0.8458654284, alpha: 1)
            cell.percentageMasteredLabel.textColor = #colorLiteral(red: 0.7439648509, green: 0.7726604342, blue: 0.8458654284, alpha: 1)
            cell.wordsMasteredLabel.textColor = #colorLiteral(red: 0.7439648509, green: 0.7726604342, blue: 0.8458654284, alpha: 1)
            cell.titleLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.progressTitleLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.masteredTitleLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.iconImage.layer.opacity = 0.5
        }
        
        let catsEng = PhraseData.shared.categoriesEng
        if catsEng.count < 12{
            cell.titleLabel.text = "-"
        }else{
            cell.titleLabel.text = "\(catsEng[indexPath.item])"
        }
        cell.iconImage.image = UIImage(named: UserData.icons[indexPath.item])
        if UserData.masteredTables.contains("\(indexPath.item)"){
            let percent = Float(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1",tableNo: "\(indexPath.item)").count) / Float(UserData.catTotals[indexPath.item])! * Float(100).rounded()
            var percentage = String()
            if percent < 1{
                percentage = "-%"
            }else{
                percentage = "\(Int(percent))%"
            }
            cell.wordsMasteredLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1", tableNo: "\(indexPath.item)").count)/\(UserData.catTotals[indexPath.item])"
            cell.percentageMasteredLabel.text = percentage
            cell.barView.progress = percent / 100
        }else{
            cell.wordsMasteredLabel.text = "0/\(UserData.catTotals[indexPath.item])"
            cell.percentageMasteredLabel.text = "-"
            cell.barView.progress = 0
        }
        
        return cell
    }
    
    func offlineReload(){
        setStats()
        setProfile(self)
    }
}
