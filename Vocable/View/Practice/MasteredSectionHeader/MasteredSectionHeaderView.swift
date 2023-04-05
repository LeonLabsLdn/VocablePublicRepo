import UIKit

class MasteredSectionHeaderView: UIView {

    let nibName = "MasteredSectionHeaderView"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var itaLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var headerBottom: NSLayoutConstraint!
    @IBOutlet weak var learningIcon: UIImageView!
    @IBOutlet weak var expandImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else {return}
        view.frame = self.bounds
        self.addSubview(view)
        learningIcon.image = UIImage(named: UserData.lang)
        statsView.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
