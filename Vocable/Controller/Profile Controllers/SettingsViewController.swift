import UIKit
import StoreKit
import SafariServices

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var expiryLabel  : UILabel!
    let appVersion = "Vocable Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Protocols.settingsDelegate = self
        tableView.backgroundColor = .clear
        expiryLabel.text = appVersion
        expiryLabel.textColor = .gray
    }
    func openURL(url:URL){
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource,SettingsDelegate{
    
    func deleteAccount(){
        view.isUserInteractionEnabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
        LoginModel.shared.deleteAcc()
    }
    
    func removeLoading(){
        view.isUserInteractionEnabled = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = nil
        LoadingAnimationView.shared.removeFromSuperview()
    }
    
    func logoutSegue(){
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    func removeRestoreLoading(state:Bool){
        LoadingAnimationView.shared.removeFromSuperview();view.isUserInteractionEnabled = true;navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = nil
        if state == true{
            present(AlertView.shared.returnRestoreSuccess(), animated: true)
        }else{
            present(AlertView.shared.returnRestoreFailure(), animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            view.isUserInteractionEnabled = false
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            navigationController?.navigationBar.isUserInteractionEnabled = false
            navigationController?.navigationBar.tintColor = UIColor.lightGray
            LoadingAnimationView.shared.center = view.center
            view.addSubview(LoadingAnimationView.shared)
            UserData.restoreCheck = true
            PurchaseModel.shared.restoreFetch()
            
        case 1:
            switch indexPath.row{
            case 0:
                guard let scene = UIApplication.shared.foregroundActiveScene else { return }
                SKStoreReviewController.requestReview(in: scene)
            default:
                openURL(url: URL(string: "https://www.leonlabs.london")!)
            }
        case 2:
            switch indexPath.row{
            case 0:
                openURL(url: URL(string: Constants.privacyPolicyURL)!)
            case 1:
                openURL(url: URL(string: Constants.serviceTermsURL)!)
            default:
                openURL(url: URL(string: Constants.acceptableUseURL)!)
            }
        default:
            switch indexPath.row{
            case 0:
                Protocols.practiceDelegate?.resetPracticeTVs()
                LoginModel.shared.logout()
            default:
                Protocols.practiceDelegate?.resetPracticeTVs()
                present(AlertView.shared.returnDeleteAccount(), animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:return 1
        case 1:return 2
        case 2:return 3
        default:return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {4}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section{
            
        case 0:content.text = "Restore purchase"
        case 1:
            switch indexPath.item{
            case 0:content.text = "Rate us"
            default:content.text = "About"
                cell.accessoryType = .disclosureIndicator
            }
        case 2:
            switch indexPath.item{
            case 0:content.text = "Privacy policy";cell.accessoryType = .disclosureIndicator
            case 1:content.text = "Terms of service";cell.accessoryType = .disclosureIndicator
            default:content.text = "Acceptable use policy";cell.accessoryType = .disclosureIndicator
            }
        default:
            switch indexPath.item{
            case 0:content.text = "Logout"
            default:content.text = "Delete account";content.textProperties.color = .red
            }
        }
        cell.contentConfiguration = content
        cell.layer.cornerRadius = 14
        cell.selectionStyle = .none
        return cell
    }
    
}
extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
