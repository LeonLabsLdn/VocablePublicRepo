import UIKit

class NoLivesViewController: UIViewController {

    @IBOutlet weak var mainView: NoLivesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.closeButton.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        mainView.cardView.goProButton.addTarget(self, action: #selector(proSegue(sender:)), for: .touchUpInside)
        mainView.getLivesButton.addTarget(self, action: #selector(getLives(sender:)), for: .touchUpInside)
        mainView.cardView.monthLabel.text = UserDefaults.standard.string(forKey: "monthPrice")
        mainView.cardView.yearLabel.text = UserDefaults.standard.string(forKey: "3monthPrice")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PurchaseModel.shared.isPro == true || UserStats.lives != 0{
            dismiss(animated: true)
        }
    }
    
    @objc func close(sender:UIButton){
        dismiss(animated: true)
    }
    
    @objc func proSegue(sender:UIButton){
        performSegue(withIdentifier: "pro", sender: self)
    }
    
    @objc func getLives(sender:UIButton){
        performSegue(withIdentifier: "getLives", sender: self)
    }
}
