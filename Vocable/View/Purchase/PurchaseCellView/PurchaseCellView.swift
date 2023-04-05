import UIKit

class PurchaseCellView: UIView {
    let nibName = "PurchaseCellView"
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var comparisonLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var comparisonHeight: NSLayoutConstraint!
    @IBOutlet weak var comparisonTop: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return };view.frame = self.bounds;self.addSubview(view)}
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}

}
