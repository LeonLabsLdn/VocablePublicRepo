import UIKit
import Foundation
import GoogleMobileAds

class CategoryPhrasesViewController: UIViewController {
    
    @IBOutlet weak var tableViewBottom  : NSLayoutConstraint!
    @IBOutlet weak var tableView        :UITableView!
    var selectedCat                     :String?
    var selectedTableNumber             :String?
    var catID                           :String?
    var faveSubAmount                   :Int?
    let phraseDelegate                  = CategoryPhrasesDelegate()
    var bannerView                      = GADBannerView(adSize: GADAdSizeBanner)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhraseData.shared.engListArr.removeAll()
        UserData.isSelected.removeAll()
        tableView.delegate = phraseDelegate
        tableView.dataSource = phraseDelegate
        addLoading()
        Protocols.phraseDelegate = self
        tableView.isHidden = true
        title = UserData.catPhrase
        retrievePhraseData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "line.horizontal.3.decrease.circle"), primaryAction: nil, menu: setupMenus())
        tableView.separatorStyle = .none
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .bottom,multiplier: 1,constant: -8),
         NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
     }

    
    override func viewWillAppear(_ animated: Bool) {
        if PurchaseModel.shared.isPro == true{
            bannerView.removeFromSuperview()
            tableViewBottom.constant = 0
        }else if bannerView.isDescendant(of: view) == false{
            bannerView.adUnitID = "ca-app-pub-1067528508711342/1506525301"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            addBannerViewToView(bannerView)
        }
        let cell = CategoryPhrasesTableViewCell()
        cell.test()
        navigationController!.tabBarItem.image = UIImage(systemName: "tray.2.fill")
    }
    
    func addLoading(){
        view.isUserInteractionEnabled = false
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
    }
    
    func reloadListTableView (){tableView.reloadData();navigationItem.setHidesBackButton(false, animated: true);LoadingAnimationView.shared.removeFromSuperview();tableView.isHidden = false}
    
    func retrievePhraseData(){
        if UserData.isFave == false{
            PhraseData.shared.retrieveCategoryList(subCat: UserData.catPhrase ?? "", tableName: selectedCat ?? "")
        }else{
            PhraseData.shared.retrieveFaveCategoryList(sub: catID!, tableName: selectedCat!, table: selectedTableNumber!)
        }
    }
    
    func selectFunction(pos:String){
        UserData.expandTest = true
        let indexPath = IndexPath(row: Int(pos)!, section: 0)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
    }
    
    func setupMenus () -> UIMenu {
        let menu = UIMenu(children:[UIAction(title: "Expand All", image: UIImage(systemName: "plus"),handler: { [self] (_) in
            var amount: Int?
            amount = 0
            UserData.isSelected.removeAll()
            for _ in PhraseData.shared.engListArr{
                UserData.isSelected.append(amount!)
                amount! += 1
            }
            self.tableView.reloadData()
        }), UIAction(title: "Collapse All", image: UIImage(systemName: "minus"),handler: { [self] (_) in
                UserData.isSelected.removeAll()
                self.tableView.reloadData()
        })])
        return menu
    }
    
    func updateFaves(value: String){
        if UserData.isFave == false{
            if PhraseData.shared.rowIDListArr.contains(value){
                let pos = PhraseData.shared.rowIDListArr.firstIndex { $0 == value }
                if PhraseData.shared.starListArr[pos!] == "star"{
                    PhraseData.shared.starListArr[pos!] = "star.fill"
                }else{
                    PhraseData.shared.starListArr[pos!] = "star"
                }
            }
            reloadListTableView()
        }
    }
    
    func addToStudyList(row:String,pos:String){
        Helpers.shared.impactFeedbackGenerator.medium.prepare()
        Helpers.shared.impactFeedbackGenerator.medium.impactOccurred()
        if PurchaseModel.shared.isPro == true{
            addLoading()
            NetworkModel.shared.updatePracticeList(row: row, table: "\(PhraseData.shared.tablePhraseListArr[0])", refreshData: true){ value in
                if value == true{
                    
                    if PhraseData.shared.studyingListArr.contains(row){
                        PhraseData.shared.studyingListArr.remove(at: PhraseData.shared.studyingListArr.firstIndex(of: row)!)
                    }else{
                        PhraseData.shared.studyingListArr.append(row)
                    }
                    let indexPath = IndexPath(row: Int(pos)!, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                self.view.isUserInteractionEnabled = true
                LoadingAnimationView.shared.removeFromSuperview()
            }
        }else{
            performSegue(withIdentifier: "pro", sender: self)
        }
    }
    
    func selectFaveFunc(row:String,pos:String){
        Helpers.shared.impactFeedbackGenerator.medium.prepare()
        Helpers.shared.impactFeedbackGenerator.medium.impactOccurred()
        if UserDefaults.standard.string(forKey: "dTableNo") == PhraseData.shared.tablePhraseListArr[0] && UserDefaults.standard.string(forKey: "dCatNo") == PhraseData.shared.subPhraseListArr[0] && UserDefaults.standard.string(forKey: "dID") == row{
            Protocols.homeDelegate?.faveLoading()
        }
        
        UserData.isLoading.append("\(PhraseData.shared.tablePhraseListArr[0]),\(PhraseData.shared.subPhraseListArr[0]),\(row)")
        let indexPath = IndexPath(row: Int(pos)!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        NetworkModel.shared.updateFave(table: PhraseData.shared.tablePhraseListArr[0], row: row, sub: PhraseData.shared.subPhraseListArr[0])
    }
}

extension CategoryPhrasesViewController:PhraseDelegate{
    
    func retrieveData(){
        retrievePhraseData()
    }
    
    func selectFave(row: String, pos: String) {
        selectFaveFunc(row: row, pos: pos)
    }
    func addToStudy(row:String,pos:String) {
        addToStudyList(row: row, pos: pos)
    }
    func showLoading() {addLoading()}
    
    func selectFunc(pos:String){
        selectFunction(pos:pos)
    }
    func updateRow(pos:Int){
        let indexPath = IndexPath(row: pos, section: 0);tableView.reloadRows(at: [indexPath], with: .none)
    }
    func updateFave(result:[String]){
        if PhraseData.shared.tablePhraseListArr.count != 0 && PhraseData.shared.subPhraseListArr.count != 0{
            if result[0] == PhraseData.shared.tablePhraseListArr[0] && result[1] == PhraseData.shared.subPhraseListArr[0] && PhraseData.shared.rowIDListArr.contains(result[2]){
                let pos = PhraseData.shared.rowIDListArr.firstIndex(of: result[2])
                if UserData.isFave != true{
                    PhraseData.shared.starListArr[pos!] = result[3]
                    let indexPath = IndexPath(row: pos!, section: 0)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    PhraseData.shared.retrieveData(completion: { value in})
                }else{
                    PhraseData.shared.rowIDListArr.remove(at: pos!)
                    PhraseData.shared.pronounceListArr.remove(at: pos!)
                    PhraseData.shared.engListArr.remove(at: pos!)
                    PhraseData.shared.itaListArr.remove(at: pos!)
                    PhraseData.shared.tablePhraseListArr.remove(at: pos!)
                    PhraseData.shared.subPhraseListArr.remove(at: pos!)
                    if PhraseData.shared.engListArr.count == 0{
                        PhraseData.shared.retrieveData(completion: { value in
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }else{
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    func checkPhraseRow(){
        if PhraseData.shared.tablePhraseListArr.count != 0 && PhraseData.shared.subPhraseListArr.count != 0{
            if UserDefaults.standard.string(forKey: "dTableNo") == PhraseData.shared.tablePhraseListArr[0] && UserDefaults.standard.string(forKey: "dCatNo") == PhraseData.shared.subPhraseListArr[0]{
                let row = PhraseData.shared.rowIDListArr.firstIndex(of: UserDefaults.standard.string(forKey: "dID")!)
                let indexPath = IndexPath(row: row!, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)}}}
    func updatePhraseList() {
        view.isUserInteractionEnabled = true
        tableView.reloadData()
        tableView.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        LoadingAnimationView.shared.removeFromSuperview()
    }
    func popToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
