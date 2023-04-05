import UIKit

class ProDescriptionViewController: UIViewController {
    
    @IBOutlet weak var restoreButton            : UIButton!
    @IBOutlet weak var mainView                 : UIView!
    @IBOutlet weak var showProPracticeExample   : UILabel!
    @IBOutlet weak var viewMembershipButton     : UIButton!
    let proExample = ProDescriptionView()
    
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Protocols.purchaseDescriptionDelegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        viewMembershipButton.layer.cornerRadius = viewMembershipButton.frame.size.height / 2
        restoreButton.layer.cornerRadius = restoreButton.frame.size.height / 2
        restoreButton.layer.borderWidth = 4
        restoreButton.layer.borderColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.15
        mainView.layer.shadowRadius = 10
        showProPracticeExample.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showExample(sender:)))
        showProPracticeExample.addGestureRecognizer(gesture)
        proExample.closeButton.addTarget(self, action: #selector(closeExample(sender:)), for: .touchUpInside)
        proExample.layer.opacity = 0
    }
    
    @IBAction func restore(_ sender: Any) {
        view.isUserInteractionEnabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
        UserData.restoreCheck1 = true
        PurchaseModel.shared.restoreFetch()
    }
    
    @IBAction func close(_ sender: Any) {dismiss(animated: true)}
    
    @objc func showExample(sender:UIGestureRecognizer){
        closeButton.isUserInteractionEnabled = false
        view.addSubview(proExample)
        proExample.frame = view.frame
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.proExample.layer.opacity = 1
        }
    }
    @objc func closeExample(sender:UIButton){
        UIView.animate(withDuration: 0.3, delay: 0) {self.proExample.layer.opacity = 0}
        closeButton.isUserInteractionEnabled = true
    }
    
}

extension ProDescriptionViewController:ProDescriptionDelegate{
    func restoreCheck(state: Bool) {
        LoadingAnimationView.shared.removeFromSuperview();view.isUserInteractionEnabled = true;navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = nil
        if state == true{
            present(AlertView.shared.returnRestoreSuccess(), animated: true)
        }else{
            present(AlertView.shared.returnRestoreFailure(), animated: true)
        }
    }
}
