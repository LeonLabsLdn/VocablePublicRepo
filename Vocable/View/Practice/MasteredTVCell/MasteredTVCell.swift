import UIKit

class MasteredTVCell: UIView {
    
    let nibName = "MasteredTVCell"
    
    @IBOutlet weak var exampleView              : UIView!
    @IBOutlet weak var exItaLabel               : UILabel!
    @IBOutlet weak var exEngLabel               : UILabel!
    @IBOutlet weak var pronounceLabel           : UILabel!
    @IBOutlet weak var itaLabel                 : UILabel!
    @IBOutlet weak var engLabel                 : UILabel!
    @IBOutlet weak var expandButton             : UIButton!
    @IBOutlet weak var speakerButton            : UIButton!
    @IBOutlet weak var exampleSpeakerButton     : UIButton!
    
    //Expand example constraints
    @IBOutlet weak var exampleEngTop            : NSLayoutConstraint!
    @IBOutlet weak var ukExampleIconTop         : NSLayoutConstraint!
    @IBOutlet weak var ukExampleIconHeight      : NSLayoutConstraint!
    @IBOutlet weak var itaExampleIconHeight     : NSLayoutConstraint!
    @IBOutlet weak var itaExampleIconTop        : NSLayoutConstraint!
    @IBOutlet weak var exampleItaTop            : NSLayoutConstraint!
    @IBOutlet weak var exampleItaBottom         : NSLayoutConstraint!
    
    @IBOutlet weak var learningIcon: UIImageView!
    @IBOutlet weak var exampleLearningIcon: UIImageView!
    
    //Full card expand constraints
    @IBOutlet weak var expandTop                : NSLayoutConstraint!
    @IBOutlet weak var expandBottom             : NSLayoutConstraint!
    @IBOutlet weak var ukIconHeight             : NSLayoutConstraint!
    @IBOutlet weak var ukIconTop                : NSLayoutConstraint!
    @IBOutlet weak var itaIconTop               : NSLayoutConstraint!
    @IBOutlet weak var itaIconHeight            : NSLayoutConstraint!
    @IBOutlet weak var ukLabelTop               : NSLayoutConstraint!
    @IBOutlet weak var itaLabelTop              : NSLayoutConstraint!
    @IBOutlet weak var pronounceTop             : NSLayoutConstraint!
    @IBOutlet weak var pronounceBottom          : NSLayoutConstraint!
    @IBOutlet weak var expandViewBottom         : NSLayoutConstraint!
    
    @IBOutlet weak var pronounceLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var itaLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var engLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var exSpeakerHeight: NSLayoutConstraint!
    @IBOutlet weak var speakerTop: NSLayoutConstraint!
    @IBOutlet weak var speakerHeight: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else{return}
        view.frame = self.bounds
        self.addSubview(view)
        learningIcon.image = UIImage(named: UserData.lang)
        exampleLearningIcon.image = UIImage(named: UserData.lang)
        exampleView.layer.cornerRadius = 5
        expandButton.layer.cornerRadius = 4
        speakerButton.addTarget(self, action: #selector(speakWord(sender: )), for: .touchUpInside)
        exampleSpeakerButton.addTarget(self, action: #selector(speakPhrase(sender: )), for: .touchUpInside)
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @objc func speakWord(sender:UIButton){
        Helpers.shared.speak(phrase: itaLabel.text ?? "")
    }
    @objc func speakPhrase(sender:UIButton){
        Helpers.shared.speak(phrase: exItaLabel.text ?? "")
    }
}

