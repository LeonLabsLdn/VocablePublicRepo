import UIKit
import StoreKit
import SafariServices

class ProPurchaseViewController: UIViewController{
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var closeView    : UIView!
    @IBOutlet weak var EULA: UILabel!
    
    let text = "Please read the end user license agreement in place for Vocable here EULA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEULA()
        Protocols.purchaseDelegate = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        restoreButton.layer.cornerRadius = restoreButton.frame.size.height / 2
        restoreButton.layer.borderWidth = 4
        restoreButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.1270889938, blue: 0.4073491991, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf(_:)))
        closeView.addGestureRecognizer(tapGesture)
        if PurchaseModel.shared.products?.count ?? 0 < 3{
            LoadingAnimationView.shared.center = view.center
            view.addSubview(LoadingAnimationView.shared)
            PurchaseModel.shared.fetchProducts()
            restoreButton.isUserInteractionEnabled = false
        }
    }
    
    func openURL(url:URL){
        let vc = SFSafariViewController(url: url);present(vc, animated: true, completion: nil)
    }
    
    func setupEULA(){
        EULA.text = text
        self.EULA.textColor =  #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
        let attriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "EULA")
        let range2 = (text as NSString).range(of: "Please read the end user license agreement in place for Vocable here")
        let range3 = (text as NSString).range(of: text)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        attriString.addAttribute(NSAttributedString.Key.paragraphStyle,value: paragraph, range: range3)
        attriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        attriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 12)!, range: range1)
        attriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Regular", size: 12)!, range: range2)
        EULA.attributedText = attriString
        EULA.isUserInteractionEnabled = true
        EULA.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    @objc func tapLabel(gesture:UITapGestureRecognizer){
        openURL(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
    }
    
    @IBAction func restore(_ sender: Any) {
        view.isUserInteractionEnabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
        UserData.restoreCheck2 = true
        PurchaseModel.shared.restoreFetch()
    }
    
    @objc func dismissSelf(_:Any){
        dismiss(animated: true)
    }
    func addLoading(){
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
    }
}

extension ProPurchaseViewController:UITableViewDelegate,UITableViewDataSource,PurchaseDelegate{
    
    func restoreCheck(state: Bool) {
        LoadingAnimationView.shared.removeFromSuperview()
        view.isUserInteractionEnabled = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = nil
        if state == true{
            present(AlertView.shared.returnRestoreSuccess(), animated: true)
        }else{
            present(AlertView.shared.returnRestoreFailure(), animated: true)
        }
    }
    
    func dismissSelf(){self.dismiss(animated: true)}
    
    func removeLoading(){
        navigationItem.hidesBackButton = false
        tableView.isUserInteractionEnabled = true
        restoreButton.isUserInteractionEnabled = true
        LoadingAnimationView.shared.removeFromSuperview()
        restoreButton.isUserInteractionEnabled = true
    }
    func reloadTableView() {
        restoreButton.isUserInteractionEnabled = false
        LoadingAnimationView.shared.removeFromSuperview()
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PurchaseCell
        addLoading()
        tableView.isUserInteractionEnabled = false
        restoreButton.isUserInteractionEnabled = false
        for products in PurchaseModel.shared.products!{
            if products.displayName == cell.mainView.titleLabel.text{
                PurchaseModel.shared.purchase(products)
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PurchaseHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 98
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PurchaseModel.shared.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCell", for: indexPath) as! PurchaseCell
        var monthDisplayPrice = String()
        for products in PurchaseModel.shared.products!{
            if products.id == "london.leonlabs.vocable.monthly"{
                monthDisplayPrice = products.displayPrice
            }
        }

        let purpleColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
        if PurchaseModel.shared.products!.count > 2{
            for products in PurchaseModel.shared.products!{
                switch products.id{
                case "london.leonlabs.vocable.monthly":
                    if indexPath.row == 0{
                        cell.mainView.titleLabel.text = products.displayName
                        cell.mainView.mainView.backgroundColor = #colorLiteral(red: 0.7398625612, green: 0.68055439, blue: 0.9612458348, alpha: 1)
                        cell.mainView.monthlyLabel.text = "\(products.displayPrice)/month"
                        cell.mainView.comparisonTop.constant = 0
                        cell.mainView.comparisonHeight.constant = 0
                    }
                case "london.leonlabs.vocable.quarterly":
                    if indexPath.row == 1{
                        cell.mainView.titleLabel.text = products.displayName
                        cell.mainView.comparisonTop.constant = 8
                        cell.mainView.comparisonHeight.constant = 23
                        var quarter = Decimal()
                        quarter = products.price / 3
                        let quarterDivided = quarter.formatted(products.priceFormatStyle)
                        let formattedQuarterly = "\(monthDisplayPrice) \(quarterDivided)/month"
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedQuarterly)
                        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: monthDisplayPrice.count))
                        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: purpleColor, range: NSRange(location: 0, length: attributedString.length))
                        attributedString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont(name: "Roboto-Regular", size: 14.0)!, range: NSRange(location: 0, length: monthDisplayPrice.count))
                        attributedString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 14.0)!, range: NSRange(location: monthDisplayPrice.count + 1, length: quarterDivided.count + 6))
                        cell.mainView.mainView.backgroundColor = #colorLiteral(red: 0.6558414698, green: 0.8777654767, blue: 0.7653483152, alpha: 1)
                        cell.mainView.comparisonLabel.attributedText = attributedString
                        cell.mainView.monthlyLabel.text = "\(products.displayPrice)/quarter"
                    }
                default:
                    if indexPath.row == 2{
                        cell.mainView.titleLabel.text = products.displayName
                        cell.mainView.comparisonTop.constant = 8
                        cell.mainView.comparisonHeight.constant = 23
                        var yearly = Decimal()
                        yearly = products.price / 12
                        let yearlyDivided = yearly.formatted(products.priceFormatStyle)
                        let formattedYearly = "\(monthDisplayPrice) \(yearlyDivided)/month"
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedYearly)
                        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: monthDisplayPrice.count))
                        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: purpleColor, range: NSRange(location: 0, length: attributedString.length))
                        attributedString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont(name: "Roboto-Regular", size: 14.0)!, range: NSRange(location: 0, length: monthDisplayPrice.count))
                        attributedString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 14.0)!, range: NSRange(location: monthDisplayPrice.count + 1, length: yearlyDivided.count + 6))
                        cell.mainView.mainView.backgroundColor = #colorLiteral(red: 0.4539441466, green: 0.8028119802, blue: 0.944560945, alpha: 1)
                        cell.mainView.comparisonLabel.attributedText = attributedString;cell.mainView.monthlyLabel.text = "\(products.displayPrice)/year"
                    }
                }
            }
        }
        cell.mainView.mainView.layer.cornerRadius = 10
        return cell
    }
}
