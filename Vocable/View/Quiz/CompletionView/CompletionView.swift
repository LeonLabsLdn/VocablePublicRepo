
import UIKit

class CompletionView: UIView {

    let nibName = "CompletionView"

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var livesView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var correctView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var livesLostTitleLabel: UILabel!
    @IBOutlet weak var heartPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartWidthConstraint: NSLayoutConstraint!
    
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
        finishButton.layer.cornerRadius = finishButton.frame.size.height / 2
        livesView.layer.cornerRadius = 5
        pointsView.layer.cornerRadius = 5
        correctView.layer.cornerRadius = 5
        mainView.layer.cornerRadius = 10
        finishButton.addTarget(self, action: #selector(finishQuiz(_:)), for: .touchUpInside)
        correctLabel.text = "\(PracticeModel.shared.correctAnswers)/\(UserData.qCount ?? 0)"
        xpLabel.text = "\(PracticeModel.shared.correctAnswers)"
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @objc func finishQuiz(_:Any){
        Protocols.quizProtocol?.close()
    }
    
}
