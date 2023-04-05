import UIKit

class SubCategoryView: UIView {

    let nibName = "SubCategoryView"
    @IBOutlet weak var itaLabel: UILabel!
    @IBOutlet weak var learningIcon: UIImageView!
    @IBOutlet weak var engLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        learningIcon.image = UIImage(named: UserData.lang)
    }
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}}
