import UIKit

class HomeStatsView: UIView {

    let nibName = "HomeStatsView"

    @IBOutlet weak var todayGoalLabel: UILabel!
    @IBOutlet weak var todayGoalLabel2: UILabel!
    @IBOutlet weak var todayGoalLabel3: UILabel!
    @IBOutlet weak var tickBox: UIImageView!
    @IBOutlet weak var tickBox2: UIImageView!
    @IBOutlet weak var tickBox3: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var dailyQuizzesCompletedLabel: UILabel!
    @IBOutlet weak var dailyPointsEarnedLabel: UILabel!
    @IBOutlet weak var dailyWordsMasteredLabel: UILabel!
    @IBOutlet weak var weeklyQuizzesCompletedLabel: UILabel!
    @IBOutlet weak var weeklyPointsEarnedLabel: UILabel!
    @IBOutlet weak var weeklyWordsMasteredLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsSubView3: UIView!
    @IBOutlet weak var statsSubView2: UIView!
    @IBOutlet weak var statsSubView1: UIView!
    @IBOutlet weak var tickBoxView: UIView!
    @IBOutlet weak var tickBoxView3: UIView!
    @IBOutlet weak var tickBoxView2: UIView!
    @IBOutlet weak var dailyStatsView: UIView!
    @IBOutlet weak var dailyStatsSubView: UIView!
    @IBOutlet weak var dailyStatsSubView2: UIView!
    @IBOutlet weak var dailyStatsSubView3: UIView!
    @IBOutlet weak var closeView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {
        guard let view = loadViewFromNib() else {return}
        view.frame = self.bounds
        self.addSubview(view)
        statsView.layer.cornerRadius = 10
        dailyStatsView.layer.cornerRadius = 10
        goalView.layer.cornerRadius = 10
        statsSubView1.layer.cornerRadius = 5
        statsSubView2.layer.cornerRadius = 5
        statsSubView3.layer.cornerRadius = 5
        dailyStatsSubView.layer.cornerRadius = 5
        dailyStatsSubView2.layer.cornerRadius = 5
        dailyStatsSubView3.layer.cornerRadius = 5
        tickBoxView.layer.cornerRadius = 5
        tickBoxView.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        tickBoxView.layer.borderWidth = 2
        tickBoxView2.layer.cornerRadius = 5
        tickBoxView2.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        tickBoxView2.layer.borderWidth = 2
        tickBoxView3.layer.cornerRadius = 5
        tickBoxView3.layer.borderColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        tickBoxView3.layer.borderWidth = 2
    }
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
}
