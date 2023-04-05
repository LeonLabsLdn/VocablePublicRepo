import UIKit

class CompletionResultView: UIView {
    
    let nibName = "CompletionResultView"
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var itaLabel: UILabel!
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var learningIcon: UIImageView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else {return}
        view.frame = self.bounds
        self.addSubview(view)
        learningIcon.image = UIImage(named: UserData.lang)
        translatesAutoresizingMaskIntoConstraints = false
        answerView.layer.cornerRadius = 10
        answerView.layer.borderWidth = 1
        answerView.layer.borderColor = #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1)
        greyView.layer.cornerRadius = 5
        layer.cornerRadius = 8
        backgroundColor = #colorLiteral(red: 0.9473914504, green: 0.9987586141, blue: 0.8883878589, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0.6667414308, green: 0.8228070736, blue: 0.4832466841, alpha: 1)
        layer.borderWidth = 2
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        continueButton.layer.cornerRadius = continueButton.frame.size.height / 2
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
