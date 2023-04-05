
import UIKit

class ChangeLanguageView: UIView {

    let nibName = "ChangeLanguageView"

    
    
    @IBOutlet weak var frenchXmark: UIImageView!
    
    @IBOutlet weak var germanXmark: UIImageView!
    @IBOutlet weak var spanishXmark: UIImageView!
    @IBOutlet weak var italianXmark: UIImageView!
    @IBOutlet weak var spanishXP: UILabel!
    @IBOutlet weak var italianXP: UILabel!
    @IBOutlet weak var germanXP: UILabel!
    @IBOutlet weak var frenchXP: UILabel!
    @IBOutlet weak var spanishView: UIView!
    @IBOutlet weak var italianView: UIView!
    @IBOutlet weak var frenchView: UIView!
    @IBOutlet weak var germanView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet var mainView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else {return}
        view.frame = self.bounds
        self.addSubview(view)
        mainView.layer.opacity = 0.8
        languageView.layer.cornerRadius = 10
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

