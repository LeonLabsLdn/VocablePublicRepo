
import UIKit

class MasteredItemsCell: UIView {
    let nibName = "MasteredItemsCell"
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ukLabel: UILabel!
    @IBOutlet weak var itaLabel: UILabel!
    @IBOutlet weak var pronounceLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    
    @IBOutlet weak var learningIcon: UIImageView!
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return };
        view.frame = self.bounds;self.addSubview(view)
        learningIcon.image = UIImage(named:UserData.lang)
        greyView.layer.cornerRadius = 5
        contentView.layer.cornerRadius = 10
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sayPhrase(sender:)))
        greyView.addGestureRecognizer(tapGesture)
        speakerButton.addTarget(self, action: #selector(sayPhrase(sender:)), for: .touchUpInside)
    }
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @objc func sayPhrase(sender:Any){
        Helpers.shared.speak(phrase: "\(itaLabel.text!)")
    }
}
