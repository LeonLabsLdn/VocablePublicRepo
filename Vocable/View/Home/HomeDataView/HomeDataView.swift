import UIKit

class HomeDataView: UIView {
    
    let nibName = "HomeDataView"
    
    @IBOutlet weak var livesButton: UIButton!
    @IBOutlet weak var masteredButton: UIButton!
    @IBOutlet weak var streakButton: UIButton!
    @IBOutlet weak var moneyImage: UIImageView!
    @IBOutlet weak var fireImage: UIImageView!
    @IBOutlet weak var lifeImage: UIImageView!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var lifeView: UIView!
    @IBOutlet weak var streakView: UIView!
    @IBOutlet weak var dailyMasteredCount: UILabel!
    @IBOutlet weak var dailyQuizCount: UILabel!
    @IBOutlet weak var proStatsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var proStatsView: UIView!
    @IBOutlet weak var proStatsBottom: NSLayoutConstraint!
    @IBOutlet weak var masteredLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var reminderMainView: UIView!
    
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var practiceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var practiceView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        reminderButton.addTarget(self, action: #selector(quickQuiz(sender:)), for: .touchUpInside)
        practiceButton.addTarget(self, action: #selector(quickQuiz(sender:)), for: .touchUpInside)
        reminderMainView.layer.cornerRadius = 10
        reminderMainView.layer.shadowColor = UIColor.gray.cgColor
        reminderMainView.layer.shadowOpacity = 0.2
        reminderMainView.layer.shadowRadius = 15
        reminderMainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        practiceView.layer.cornerRadius = 10
        practiceView.layer.shadowColor = UIColor.gray.cgColor
        practiceView.layer.shadowOpacity = 0.2
        practiceView.layer.shadowRadius = 15
        practiceView.layer.shadowOffset = CGSize(width: 0, height: 1)
        practiceButton.layer.borderWidth = 2
        practiceButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        practiceButton.layer.cornerRadius = practiceButton.frame.size.height / 2
        reminderButton.layer.borderWidth = 2.5
        reminderButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        reminderButton.layer.cornerRadius = reminderButton.frame.size.height / 2
        proStatsView.layer.cornerRadius = 10
        livesButton.layer.borderWidth = 2
        livesButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        livesButton.layer.cornerRadius = livesButton.frame.size.height / 2
        masteredButton.layer.borderWidth = 2
        masteredButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        masteredButton.layer.cornerRadius = masteredButton.frame.size.height / 2
        streakButton.layer.borderWidth = 2
        streakButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        streakButton.layer.cornerRadius = streakButton.frame.size.height / 2
        lifeImage.layer.opacity = 0;fireImage.layer.opacity = 0
        moneyImage.layer.opacity = 0
        lifeImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        fireImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        moneyImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.3,delay: 0.15, options: [],animations: { [self] in
            fireImage.layer.opacity = 1
            fireImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        UIView.animate(withDuration: 0.3,delay: 0, options: [],animations: { [self] in
            lifeImage.layer.opacity = 1
            lifeImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        UIView.animate(withDuration: 0.3,delay: 0.3, options: [],animations: { [self] in
            moneyImage.layer.opacity = 1
            moneyImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        setMasteredLabel()
        if PurchaseModel.shared.isPro == true{
            livesButton.setTitle("Profile", for: .normal)
            masteredButton.setTitle("Practice", for: .normal)
        }else{
            livesButton.setTitle("Get lives", for: .normal)
            masteredButton.setTitle("Go pro", for: .normal)
        }
        
        
    }
    
    func setMasteredLabel(){
        if PurchaseModel.shared.isPro == true{
            var amount = 0
            for v in UserData.masteredTables{
                amount = amount + DataModel.shared.proListDataQuery(value: "proEngArr", mastered:"1",tableNo: "\(v)").count
            }
            let percent = Float(amount) / Float(UserDefaults.standard.integer(forKey: "totalRows")) * Float(100).rounded()
            var percentage = String()
            if "\(percent)" == "nan"{
                percentage = "-%"
            }else if percent < 1{
                percentage = "0%"
            }else{
                percentage = "\(Int(percent))%"
            }
            masteredLabel.text = "\(percentage) Mastered"
        }
    }
    
    @objc func quickQuiz(sender:UIButton){
        if PhraseData.shared.categoriesEng.count != 0{
            Protocols.homeDelegate?.startQuiz(cat: "\(PhraseData.shared.categoriesEng.randomElement()!)")
        }
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
