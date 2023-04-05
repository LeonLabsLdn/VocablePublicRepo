import UIKit

class NoLivesView: UIView {

    let nibName = "NoLivesView"
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var getLivesButton: UIButton!
    @IBOutlet weak var cardView: HomeProView!
    @IBOutlet weak var livesCard: UIView!
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return };view.frame = self.bounds;self.addSubview(view)
        cardView.closeButton.isHidden = true
        getLivesButton.layer.cornerRadius = getLivesButton.frame.size.height / 2
        getLivesButton.layer.borderWidth = 4
        getLivesButton.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        livesCard.layer.cornerRadius = 10
        livesCard.layer.shadowColor = UIColor.gray.cgColor
        livesCard.layer.shadowOpacity = 0.15
        livesCard.layer.shadowRadius = 10
    }
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
}
