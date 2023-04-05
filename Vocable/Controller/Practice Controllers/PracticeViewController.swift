import UIKit
import Foundation
import Lottie

class PracticeViewController: UIViewController {
    
    let refreshControl                      = UIRefreshControl()
    let nonProView                          = NonProView()
    var isProView                           = false
    var loaded                              = false
    var selected                            : String?
    var proQuiz                             : Bool?
    var tvPos                               : CGPoint?
    var vd                                  : Bool?
    var end                                 : Bool?
    private var animationView               : LottieAnimationView?
    @IBOutlet weak var masteredTableView    : UITableView!
    @IBOutlet weak var statsView            : PracticeStatsView!
    @IBOutlet weak var rightBarView         : LivesBarView!
    @IBOutlet weak var leftBarView          : XPBarView!
    @IBOutlet weak var segmentedView        : SegmentedControlView!
    @IBOutlet weak var statsHeight          : NSLayoutConstraint!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var segmentedControl     : UISegmentedControl!
    @IBOutlet weak var barButtonItem        : UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedView.leftButton.setTitle("Categories", for: .normal)
        segmentedView.rightButton.setTitle("Study List", for: .normal)
        segmentedView.rightButton.addTarget(self, action: #selector(setSegmentedView(sender:)), for: .touchUpInside)
        segmentedView.leftButton.addTarget(self, action: #selector(setSegmentedView(sender:)), for: .touchUpInside)
        statsView.collapseButton.addTarget(self, action: #selector(closeStats(sender:)), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeStats(sender:)))
        statsView.addGestureRecognizer(gesture)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
        masteredTableView.tableFooterView = footerView
        tableView.delegate = ProPracticeDelegate.shared
        tableView.dataSource = ProPracticeDelegate.shared
        masteredTableView.delegate = MasteredDelegate.shared
        masteredTableView.dataSource = MasteredDelegate.shared
        let t = [tableView,masteredTableView]
        for v in t{v!.sectionHeaderHeight = UITableView.automaticDimension
            v!.rowHeight = UITableView.automaticDimension
            v!.sectionHeaderTopPadding = 0
            v?.separatorStyle = .none
            v!.showsVerticalScrollIndicator = false
        }
        tableView.register(EmptyListTableViewCell.self, forCellReuseIdentifier: "emptylistcell")
        tableView.register(StartTableViewCell.self, forCellReuseIdentifier: "phrasecellstart")
        masteredTableView.register(MasteredTableViewCell.self, forCellReuseIdentifier: "masteredcell")
        masteredTableView.register(EmptyMasteredTableViewCell.self, forCellReuseIdentifier: "emptymastered")
        Protocols.practiceDelegate = self
        view.addSubview(nonProView)
        nonProView.translatesAutoresizingMaskIntoConstraints = false
        nonProView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nonProView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor, constant: 16).isActive = true
        nonProView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nonProView.proButton.addTarget(self, action: #selector(self.proSegue(_:)), for: .touchUpInside)
        nonProView.isHidden = true
        PracticeCollectionView.shared.collectionView.delegate = self
        PracticeCollectionView.shared.collectionView.dataSource = self
        view.addSubview(PracticeCollectionView.shared.collectionView)
        PracticeCollectionView.shared.collectionView.translatesAutoresizingMaskIntoConstraints = false
        PracticeCollectionView.shared.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        PracticeCollectionView.shared.collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        PracticeCollectionView.shared.collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        PracticeCollectionView.shared.collectionView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor, constant: 0).isActive = true
        DispatchQueue.main.async { [self] in
            masteredTableView.reloadData()
            tableView.reloadData()
        }
        checkPro()
    }
    
    func checkPro(){
        if PurchaseModel.shared.isPro == true{
            updatePStats()
            rightBarView.livesLabel.text = "∞"
            refreshControl.addTarget(self, action: #selector(pullData(_:)), for: .valueChanged)
            tableView.addSubview(refreshControl)
            if isProView == true{
                PracticeCollectionView.shared.collectionView.isHidden = true
                statsView.isHidden = false
                segmentedControl.isHidden = false
                nonProView.isHidden = true
                if segmentedControl.selectedSegmentIndex == 1{
                    masteredTableView.isHidden = false
                    tableView.isHidden = true
                }else{
                    masteredTableView.isHidden = true
                    tableView.isHidden = false
                }
            }else{
                hideProViews()
                PracticeCollectionView.shared.collectionView.isHidden = false
            }
        }else{
            hideProViews()
            rightBarView.livesLabel.text = "\(UserStats.lives)"
            if isProView == false{
                setTabBar()
                PracticeCollectionView.shared.collectionView.isHidden = false
                nonProView.isHidden = true
            }else{
                PracticeCollectionView.shared.collectionView.isHidden = true
                nonProView.isHidden = false
            }
        }
        setTabBar()
    }
    
    //custom segmented control method
    @objc func setSegmentedView(sender:UIButton){
        PracticeCollectionView.shared.collectionView.setContentOffset(PracticeCollectionView.shared.collectionView.contentOffset, animated:false)
        if sender == segmentedView.leftButton{
            segmentedView.leftButton.titleLabel?.font =  UIFont(name: "Roboto-Bold", size: 16)
            segmentedView.rightButton.titleLabel?.font =  UIFont(name: "Roboto-Regular", size: 16)
            segmentedView.leftButton.setTitleColor(#colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1), for: .normal)
            segmentedView.rightButton.setTitleColor(#colorLiteral(red: 0.5547398925, green: 0.5445776582, blue: 0.5621618629, alpha: 1), for: .normal)
            segmentedView.leftView.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            segmentedView.rightView.backgroundColor = .white
            isProView = false
        }else{
            segmentedView.leftButton.titleLabel?.font =  UIFont(name: "Roboto-Regular", size: 16)
            segmentedView.rightButton.titleLabel?.font =  UIFont(name: "Roboto-Bold", size: 16)
            segmentedView.rightButton.setTitleColor(#colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1), for: .normal)
            segmentedView.leftButton.setTitleColor(#colorLiteral(red: 0.5547398925, green: 0.5445776582, blue: 0.5621618629, alpha: 1), for: .normal)
            segmentedView.rightView.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            segmentedView.leftView.backgroundColor = .white
            isProView = true
        }
        checkPro()
    }
    
    //set tabBar opacity
    func setTabBar(){
        vd = true
        if end == true && isProView == false || isProView == true && PurchaseModel.shared.isPro != true{
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
        if UserData.listSegue == true{
            UserData.listSegue = false
            setSegmentedView(sender: segmentedView.rightButton)
        }
    }
    
    //view will appear
    override func viewWillAppear(_ animated: Bool) {
        if UserData.masteredData.count != 0{
            tabBarController?.tabBar.isUserInteractionEnabled = false
            MasteredItemsView.shared.reloadDataView()
            view.addSubview(MasteredItemsView.shared)
            MasteredItemsView.shared.frame = view.frame
            let subClassedView = subClassUIView()
            view.addSubview(subClassedView)
            subClassedView.frame = view.frame
            animationView = .init(name: "confetti")
            animationView!.frame = subClassedView.bounds
            animationView!.contentMode = .scaleAspectFit
            animationView!.loopMode = .playOnce
            animationView!.animationSpeed = 1.3
            subClassedView.addSubview(animationView!)
            animationView?.tag = 28
            animationView?.isUserInteractionEnabled = false
            animationView?.play()
        }
        navigationController!.tabBarItem.image = UIImage(systemName: "book.fill")
        leftBarView.xpLabel.text = "\(UserStats.xp)XP"
        leftBarView.icon.image = UIImage(named: UserData.lang)
        checkPro()
        setTabBar()
    }
    
    //update user stats
    func updatePStats(){
        statsView.currentAmount.text = "\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0", tableNo: "").count)"
        var amount = 0
        for v in UserData.masteredTables{amount = amount + DataModel.shared.proListDataQuery(value: "proEngArr", mastered:"1",tableNo: "\(v)").count}
        statsView.masteredAmount.text = "\(amount)"
        let progress = Float(amount) / Float(UserDefaults.standard.integer(forKey: "totalRows"))
        let percentageAmount = (amount * 100) / UserDefaults.standard.integer(forKey: "totalRows")
        statsView.percentageMastered.text = "\(percentageAmount)%"
        statsView.progressBar.progress = Float(progress)
    }
    
    //initiate pro quiz
    @objc func startProQuiz(_:Any) {
        Helpers.shared.impactFeedbackGenerator.medium.prepare()
        Helpers.shared.impactFeedbackGenerator.medium.impactOccurred()
        if PurchaseModel.shared.isPro == true{
            self.proQuiz = true
            self.performSegue(withIdentifier: "practice", sender: self)
        }else{
            self.checkPro()
        }
    }
    
    //segue to pro purchase screens
    @objc func proSegue(_:Any){
        performSegue(withIdentifier: "pro", sender: self)
    }
    
    //expand stats function
    @objc func closeStats(sender:Any) {
        var ovalue = Float();var tvalue = CGFloat();var sheight = CGFloat();var bimage = String()
        if statsView.collapseButton.image(for: .normal) != UIImage(systemName: "chevron.down"){
            ovalue = 0;tvalue = 16;sheight = 51;bimage = "chevron.down"
        }else{
            ovalue = 1;tvalue = 126;sheight = 150;bimage = "chevron.up"
        }
        statsView.titleLabelConstraint.constant = tvalue
        statsHeight.constant = sheight
        UIView.animate(withDuration: 0.2, animations: { [self] in
            statsView.dataView1.layer.opacity   = ovalue
            statsView.dataView2.layer.opacity   = ovalue
            statsView.imageView.layer.opacity   = ovalue
            view.layoutSubviews()
            statsView.layoutSubviews()
            statsView.mainView.layoutSubviews()
            statsView.collapseButton.setImage(UIImage(systemName: bimage), for: .normal)
        })
    }
    
    //Hide all proviews
    func hideProViews(){
        statsView.isHidden = true
        segmentedControl.isHidden = true
        tableView.isHidden = true
        masteredTableView.isHidden = true
    }
    
    //pro segmented controller
    @IBAction func segmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            masteredTableView.isHidden = true
            tableView.isHidden = false
        default:
            masteredTableView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    //refresh control method (update data)
    @objc func pullData(_ sender: AnyObject) {
        if PurchaseModel.shared.isPro == true{
            NetworkModel.shared.retrieveProPractice()
            Helpers.shared.impactFeedbackGenerator.light.prepare()
            Helpers.shared.impactFeedbackGenerator.light.impactOccurred()
            refreshControl.endRefreshing()
        }
    }
    
    //setup quiz the prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let practice = segue.destination as? QuizControllerViewController
        if segue.identifier == "practice"{
            if proQuiz == true{
                practice!.category = "pro"
                var count = 0
                for _ in DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0", tableNo: ""){
                    practice?.proWordList.append("\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0", tableNo: "")[count])_\(DataModel.shared.proListDataQuery(value: "proItaArr", mastered: "0", tableNo: "")[count])")
                    practice?.proPhraseList.append("\(DataModel.shared.proListDataQuery(value: "proEngExampleArr", mastered: "0", tableNo: "")[count])_\(DataModel.shared.proListDataQuery(value: "proItaExampleArr", mastered: "0", tableNo: "")[count])")
                    practice?.proPronounceList.append("\(DataModel.shared.proListDataQuery(value: "proPronounceArr", mastered: "0", tableNo: "")[count])")
                    count += 1
                }
            }else{
                practice!.category = selected!}
        }
    }
    
    //view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.tabBarItem.image = UIImage(systemName: "book")
        vd = false
    }
    
}

extension PracticeViewController:PracticeDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //remove loading
    func removeLoading(){
        LoadingAnimationView.shared.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    //addLoading
    func addLoading(){
        view.isUserInteractionEnabled = false
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
    }
    
    //expand mastered section
    func masteredSectionTapped(add:Bool,section:Int){
        let r = masteredTableView.rect(forSection: section)
        if add == true{
            masteredTableView.reloadSections(IndexSet(integer: section), with: .fade)
            let sectionRect = masteredTableView.rect(forSection: section)
            masteredTableView.setContentOffset(CGPoint(x: sectionRect.origin.x, y: sectionRect.origin.y), animated: true)
        }else{
            UIView.performWithoutAnimation {
                masteredTableView.reloadSections(IndexSet(integer: section), with: .fade)
            }
            DispatchQueue.main.async {
                self.masteredTableView.contentOffset.y = r.minY
            }
        }
    }
    
    //expand mastered cell
    func masteredCellTapped(indexPath:IndexPath) {
        UserData.expandTest = true
        masteredTableView.delegate?.tableView!(masteredTableView, didSelectRowAt: indexPath)
    }
    
    //start a quiz
    func startQuiz(cat: String, isPro:Bool){
        if ConnectivityManager.checkNetworkStatus != true{
            present(AlertView.shared.offlineAlert(), animated: true)
        }else{
            if PurchaseModel.shared.isPro == true || UserStats.lives != 0{
                if isPro == false{
                    selected = cat
                    proQuiz = false
                }else{
                    proQuiz = true
                }
                performSegue(withIdentifier: "practice", sender: self)
            }else{
                performSegue(withIdentifier: "noLives", sender: self)
            }
        }
    }
    
    //plain reload of all tableviews
    func updatePracticeTV() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.masteredTableView.reloadData()
            PracticeCollectionView.shared.collectionView.reloadData()
            self.removeLoading()
        }
    }
    
    //delegate mathod to update user stats
    func updatePStat(){updatePStats()}
    
    //to remove collectionview showing mastered words after succesfully mastering a word
    func removeMasteredView(){UserData.masteredData.removeAll()
        MasteredItemsView.shared.removeFromSuperview()
        tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    //for logout
    func resetPracticeTVs(){
        tableView.setContentOffset(.zero, animated: false)
        masteredTableView.setContentOffset(.zero, animated: false)
    }
    func hideSegmentedView(){
        PracticeCollectionView.shared.collectionView.isHidden = true
    }
    
    //practice cv cell clicked (initiate non pro quiz)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PracticeCell
        if cell.ukLabel.text != "-"{
            Protocols.practiceDelegate?.startQuiz(cat: cell.ukLabel.text!, isPro: false)
        }
    }
    
    //No. of items in non pro collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let catsEng = PhraseData.shared.categoriesEng
        return catsEng.count
    }
    
    //Update tabBar with scrollview position for non pro CV
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loaded == true{
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
        }else{
            loaded = true
        }
    }
    
    //define and return non pro collectionview cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PracticeCell
        cell.itaIcon.image = UIImage(named: UserData.lang)
        let catsEng = PhraseData.shared.categoriesEng
        let catsIta = PhraseData.shared.categoriesTranslated
        if catsEng.count < 12{
            cell.itaLabel.text = "-"
            cell.ukLabel.text = "-"
        }else{
            cell.itaLabel.text = "\(catsIta[indexPath.item])"
            cell.ukLabel.text = "\(catsEng[indexPath.item])"
        }
        cell.icon.image = UIImage(named: UserData.icons[indexPath.item])
        return cell
    }
}

//subclass to allow touch through animation
class subClassUIView:UIView{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
