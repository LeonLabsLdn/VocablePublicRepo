import UIKit

class LivesBarView: UIView {
    
    let nibName = "LivesBarView"
    
    @IBOutlet weak var livesLabel: UILabel!
    
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
        if PurchaseModel.shared.isPro != true{
            livesLabel.text = "\(UserStats.lives)"
        }else{
            livesLabel.text = "∞"
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

