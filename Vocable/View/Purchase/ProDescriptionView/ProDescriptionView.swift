import UIKit

class ProDescriptionView: UIView {
    
    let nibName = "ProDescriptionView"

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return };view.frame = self.bounds;self.addSubview(view)
                view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        mainView.layer.cornerRadius = 10
    }
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
}

