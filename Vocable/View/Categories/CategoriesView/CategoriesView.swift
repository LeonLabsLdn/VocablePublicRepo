import UIKit

class CategoriesView: UIView {
    
    let nibName = "CategoriesView"
    
    @IBOutlet weak var itaLabel: UILabel!
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet var topView: UIView!
    
    @IBOutlet weak var learningIcon: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.15;view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

