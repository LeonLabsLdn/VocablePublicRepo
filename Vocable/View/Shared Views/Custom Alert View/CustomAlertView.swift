import UIKit

class CustomAlertView: UIView {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var mainView: UIView!
    let nibName = "CustomAlertView"
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return };view.frame = self.bounds;self.addSubview(view);layer.borderWidth = 1;layer.borderColor = #colorLiteral(red: 0.628931284, green: 0.04916673899, blue: 0, alpha: 1);layer.cornerRadius = 6}
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
}
