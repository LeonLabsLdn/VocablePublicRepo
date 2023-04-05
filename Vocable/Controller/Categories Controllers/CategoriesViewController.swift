import UIKit
import Foundation
import GoogleMobileAds

class CategoriesViewController: UIViewController {

    @IBOutlet weak var segmentedControlView     : SegmentedControlView!
    @IBOutlet weak var placeholderImage         : UIImageView!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var leftBarView              : XPBarView!
    var bannerView                              = GADBannerView(adSize: GADAdSizeBanner)
    @IBOutlet weak var placeholderImageBottom   : NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom          : NSLayoutConstraint!
    @IBOutlet weak var livesVew                 : LivesBarView!
    var selected                                :String?
    var rowSelected                             :Int?
    var faveSelected                            :Bool?
    var end                                     :Bool?
    var vd                                      :Bool?
    
    override func viewDidLoad() {
        segmentedControlView.leftButton.setTitle("All", for: .normal)
        segmentedControlView.rightButton.setTitle("Favourites", for: .normal)
        segmentedControlView.rightButton.addTarget(self, action: #selector(segmentedControlViewController(sender:)), for: .touchUpInside)
        segmentedControlView.leftButton.addTarget(self, action: #selector(segmentedControlViewController(sender:)), for: .touchUpInside)
        faveSelected = false
        Protocols.categoriesDelegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
    }

    override func viewWillAppear(_ animated: Bool) {
        leftBarView.xpLabel.text = "\(UserStats.xp)XP"
        leftBarView.icon.image = UIImage(named: UserData.lang)
        if PurchaseModel.shared.isPro == true{
            livesVew.livesLabel.text = "∞"
            bannerView.removeFromSuperview()
            tableViewBottom.constant = 0
            placeholderImageBottom.constant = 0
        }else{
            livesVew.livesLabel.text = "\(UserStats.lives)"
            if bannerView.isDescendant(of: view) == false{
                tableViewBottom.constant = 66
                placeholderImageBottom.constant = 66
                bannerView.adUnitID = "ca-app-pub-1067528508711342/8459828343"
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
                addBannerViewToView(bannerView)
            }
        }
        vd = true
        if end == true{
                end = true
                tabBarController?.tabBar.scrollEdgeAppearance = nil
                self.tabBarController!.tabBar.layer.borderWidth = 0.50
                self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
                self.tabBarController?.tabBar.clipsToBounds = true
        }else{
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                tabBarController?.tabBar.standardAppearance = appearance
                self.tabBarController!.tabBar.layer.borderWidth = 0.0
                self.tabBarController!.tabBar.layer.borderColor = nil
                self.tabBarController?.tabBar.clipsToBounds = false
                tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
        }
        navigationController!.tabBarItem.image = UIImage(systemName: "tray.2.fill")
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .bottom,multiplier: 1,constant: -8),
         NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.tabBarItem.image = UIImage(systemName: "tray.2")
        vd = false
    }
    
    func reloadTableView (){
        if faveSelected == true{
            if PhraseData.shared.faveTables.count == 0{
                tableView.isHidden = true
                placeholderImage.image = UIImage(named: "favePlaceholder")
                placeholderImage.contentMode = .center
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                placeholderImage.image = UIImage(named: "faveBG")
                placeholderImage.contentMode = .bottom
                tableView.isHidden = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }else{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let subCat = segue.destination as? SubCategoryViewController
        if segue.identifier == "sub"{
            subCat!.isFave = faveSelected!
            subCat!.category = selected!
            subCat!.rowSelected = rowSelected ?? 0
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        performSegue(withIdentifier: "search", sender: self)
    }
    
    @objc func segmentedControlViewController(sender:UIButton){
        if sender == segmentedControlView.leftButton{
            segmentedControlView.leftButton.titleLabel?.font =  UIFont(name: "Roboto-Bold", size: 16)
            segmentedControlView.rightButton.titleLabel?.font =  UIFont(name: "Roboto-Regular", size: 16)
            segmentedControlView.leftButton.setTitleColor(#colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1), for: .normal)
            segmentedControlView.rightButton.setTitleColor(#colorLiteral(red: 0.5547398925, green: 0.5445776582, blue: 0.5621618629, alpha: 1), for: .normal)
            segmentedControlView.leftView.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            segmentedControlView.rightView.backgroundColor = .white
            faveSelected = false
            tableView.isHidden = false
            placeholderImage.isHidden = true
            reloadTableView()
        }else{
            segmentedControlView.leftButton.titleLabel?.font =  UIFont(name: "Roboto-Regular", size: 16)
            segmentedControlView.rightButton.titleLabel?.font =  UIFont(name: "Roboto-Bold", size: 16)
            segmentedControlView.rightButton.setTitleColor(#colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1), for: .normal)
            segmentedControlView.leftButton.setTitleColor(#colorLiteral(red: 0.5547398925, green: 0.5445776582, blue: 0.5621618629, alpha: 1), for: .normal)
            segmentedControlView.rightView.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            segmentedControlView.leftView.backgroundColor = .white
            placeholderImage.isHidden = false
            faveSelected = true
            reloadTableView()
        }
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource,CategoriesDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! CategoriesTableViewCell
        if faveSelected == true{
            rowSelected = Int("\(PhraseData.shared.faveTables[indexPath.item])")
            PhraseData.shared.catID = PhraseData.shared.categoriesEng.firstIndex(of: cell.categoriesView.engLabel.text!)
        }else{
            PhraseData.shared.catID = indexPath.row
        }
        selected = cell.categoriesView.engLabel.text
        if cell.categoriesView.engLabel.text != "-"{
            self.performSegue(withIdentifier: "sub", sender: self)
        }
    }
    
    func setViewLeft(){
        segmentedControlViewController(sender: segmentedControlView.leftButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if faveSelected == false{
            return PhraseData.shared.categoriesEng.count
        }
        return PhraseData.shared.faveTables.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height + 10
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
                end = true
                if vd != false{
                    tabBarController?.tabBar.scrollEdgeAppearance = nil
                    tabBarController!.tabBar.layer.borderWidth = 0.50
                    tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
                    tabBarController?.tabBar.clipsToBounds = true
                }
        }else{
            end = false
            if vd != false{
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                tabBarController?.tabBar.standardAppearance = appearance
                tabBarController!.tabBar.layer.borderWidth = 0.0
                tabBarController!.tabBar.layer.borderColor = nil
                tabBarController?.tabBar.clipsToBounds = false
                tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ccell", for: indexPath) as! CategoriesTableViewCell
        cell.categoriesView.learningIcon.image = UIImage(named: UserData.lang)
        if indexPath.item == 0{
            cell.cellTop.constant = 12
        }else{
            cell.cellTop.constant = 8
        }
        if faveSelected == false{
            cell.categoriesView.imageView.image = UIImage(named: UserData.icons[indexPath.row])
            cell.categoriesView.engLabel.text = PhraseData.shared.categoriesEng[indexPath.item]
            cell.categoriesView.itaLabel.text = PhraseData.shared.categoriesTranslated[indexPath.item]
            if indexPath.item == PhraseData.shared.categoriesEng.count - 1{
                cell.cellBottom.constant = 16
            }else{
                cell.cellBottom.constant = 8
            }
        }else{
            if indexPath.item == PhraseData.shared.faveTables.count - 1{
                cell.cellBottom.constant = 16
            }else{
                cell.cellBottom.constant = 8
            }
            if PhraseData.shared.faveTables.count == 0{
                return cell
            }
            cell.categoriesView.imageView.image = UIImage(named:UserData.icons[Int(PhraseData.shared.faveTables[indexPath.item]) ?? 0])
            cell.categoriesView.engLabel.text = PhraseData.shared.categoriesEng[Int (PhraseData.shared.faveTables[indexPath.item]) ?? 0]
            cell.categoriesView.itaLabel.text = PhraseData.shared.categoriesTranslated[Int (PhraseData.shared.faveTables[indexPath.item]) ?? 0]
        }
        return cell
    }
    func reloadCatTableView(){
        LoadingAnimationView.shared.removeFromSuperview()
        reloadTableView()
    }
}
