import UIKit

class StudyListCellView: UIView {
    
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var itaLabel: UILabel!
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var pronounceLabel: UILabel!
    @IBOutlet weak var exEngLabel: UILabel!
    @IBOutlet weak var exItaLabel: UILabel!
    @IBOutlet weak var exampleSpeakerButton: UIButton!
    @IBOutlet weak var exampleCardView: UIView!
    @IBOutlet weak var topCardView: UIView!
    
    @IBOutlet weak var exampleLearningIcon: UIImageView!
    @IBOutlet weak var learningIcon: UIImageView!
    let nibName = "StudyListCellView"
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        topCardView.layer.cornerRadius = 10
        topCardView.layer.shadowOpacity = 0.15
        greyView.layer.cornerRadius = 10
        exampleCardView.layer.cornerRadius = 10
        topCardView.layer.shadowRadius = 10
        topCardView.layer.shadowColor = UIColor.gray.cgColor
        topCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        exampleCardView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        speakerButton.addTarget(self, action: #selector(speakWord(sender:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(speakWord(sender:)))
        greyView.isUserInteractionEnabled = true
        greyView.addGestureRecognizer(tap)
        exampleSpeakerButton.addTarget(self, action: #selector(speakPhrase(sender:)), for: .touchUpInside)
        removeButton.configuration?.contentInsets.leading = .zero
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @objc func speakWord(sender:Any){
        Helpers.shared.speak(phrase: itaLabel.text ?? "")
    }
    @objc func speakPhrase(sender:UIButton){
        Helpers.shared.speak(phrase: exItaLabel.text ?? "")
    }
}
