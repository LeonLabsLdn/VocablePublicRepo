import UIKit

class PracticeStatsView: UIView {
    let nibName = "PracticeStatsView"
    
    @IBOutlet weak var dataView1: UIView!
    @IBOutlet weak var dataView2: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var masteredAmount: UILabel!
    @IBOutlet weak var percentageMastered: UILabel!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard
        let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        mainView.layer.cornerRadius = 10
        dataView1.layer.cornerRadius = 5
        dataView2.layer.cornerRadius = 5
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
