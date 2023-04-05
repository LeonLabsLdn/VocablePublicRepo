import UIKit

class SharedCardView: UIView {
    
    let nibName = "SharedCardView"
    
    @IBOutlet weak var greyView         : UIView!
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var engLabel         : UILabel!
    @IBOutlet weak var itaLabel         : UILabel!
    @IBOutlet weak var pronounceLabel   : UILabel!
    @IBOutlet weak var faveButton       : UIButton!
    @IBOutlet weak var addButton        : UIButton!
    @IBOutlet weak var expandView       : UIView!
    @IBOutlet weak var expandButton     : UIImageView!
    @IBOutlet weak var exampleLabelTop  : NSLayoutConstraint!
    @IBOutlet weak var exampleLabel     : UILabel!
    @IBOutlet weak var itaExample       : UILabel!
    @IBOutlet weak var itaIconHeight    : NSLayoutConstraint!
    @IBOutlet weak var ukIconHeight     : NSLayoutConstraint!
    @IBOutlet weak var ukIconTop        : NSLayoutConstraint!
    @IBOutlet weak var itaLabelHeight   : NSLayoutConstraint!
    @IBOutlet weak var engLabelHeight   : NSLayoutConstraint!
    @IBOutlet weak var cardBottom       : NSLayoutConstraint!
    @IBOutlet weak var engExampleIcon   : UIImageView!
    @IBOutlet weak var itaExampleIcon   : UIImageView!
    @IBOutlet var mainView              : UIView!
    @IBOutlet weak var spinner          : UIActivityIndicatorView!
    @IBOutlet weak var cardTop          : NSLayoutConstraint!
    @IBOutlet weak var addHeight        : NSLayoutConstraint!
    @IBOutlet weak var addBottom        : NSLayoutConstraint!
    @IBOutlet weak var speakerButton    : UIButton!
    
    @IBOutlet weak var learningExampleIcon: UIImageView!
    @IBOutlet weak var learningIcon: UIImageView!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var pronounceBottom: NSLayoutConstraint!
    @IBOutlet weak var pronounceHeight: NSLayoutConstraint!
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        greyView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        expandView.layer.cornerRadius = 10
//        addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        if #available(iOS 16.0, *){
            exampleLabel.preferredMaxLayoutWidth = view.frame.size.width - 38
            itaExample.preferredMaxLayoutWidth = view.frame.size.width - 73
        }else{
            exampleLabel.preferredMaxLayoutWidth = view.frame.size.width - 52
            itaExample.preferredMaxLayoutWidth = view.frame.size.width - 88
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sayPhrase(sender: )))
        greyView.removeGestureRecognizer(tap)
        greyView.addGestureRecognizer(tap)
        speakerButton.addTarget(self, action: #selector(sayExample(sender:)), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandCard(_:)))
        expandView.isUserInteractionEnabled = true
        expandView.addGestureRecognizer(gesture)
    }
    
    @objc func sayExample(sender:UIButton){
        Helpers.shared.speak(phrase: itaExample.text ?? "")
    }
    @objc func sayPhrase(sender:UITapGestureRecognizer){
        Helpers.shared.speak(phrase: itaLabel.text ?? "")
    }
    
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
    
    @objc func expandCard(_:Any){
        if expandButton.image == UIImage(systemName: "chevron.down"){
            expandButton.image = UIImage(systemName: "chevron.up")
            engLabelHeight.constant = exampleLabel.intrinsicContentSize.height
            itaLabelHeight.constant = itaExample.intrinsicContentSize.height
            speakerButton.alpha = 1
            itaExample.alpha = 1
            exampleLabel.alpha = 1
            itaExampleIcon.alpha = 1
            engExampleIcon.alpha = 1
            exampleLabelTop.constant = 61
            itaIconHeight.constant = 14
            ukIconHeight.constant = 14
            ukIconTop.constant = 16
        }else{
            expandButton.image = UIImage(systemName: "chevron.down")
            speakerButton.alpha = 0
            itaExample.alpha = 0
            exampleLabel.alpha = 0
            engExampleIcon.alpha = 0
            itaExampleIcon.alpha = 0
            engLabelHeight.constant = 0
            itaLabelHeight.constant = 0
            exampleLabelTop.constant = 35
            itaIconHeight.constant = 0
            ukIconHeight.constant = 0
            ukIconTop.constant = 5
        }
        UIView.animate(withDuration: 0.2, animations: { [self] in
            expandView.layoutSubviews()
            mainView.layoutSubviews()
            Protocols.homeDelegate!.refreshContent()
        })
    }
}
