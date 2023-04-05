import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var mainView: HomeStatsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.streakLabel.text = "\(UserStats.streakCount) day streak"
        if UserStats.stats.count != 0{
            if UserStats.stats[0] >= 5{
                mainView.tickBox.image = UIImage(systemName: "checkmark")
                mainView.tickBox2.image = UIImage(systemName: "checkmark")
                mainView.tickBox3.image = UIImage(systemName: "checkmark")
                mainView.todayGoalLabel.text = "1/1 20XP"
                mainView.todayGoalLabel2.text = "3/3 50XP"
                mainView.todayGoalLabel3.text = "5/5 70XP"
            }else if UserStats.stats[0] >= 3{
                mainView.tickBox.image = UIImage(systemName: "checkmark")
                mainView.tickBox2.image = UIImage(systemName: "checkmark")
                mainView.todayGoalLabel.text = "1/1 20XP"
                mainView.todayGoalLabel2.text = "3/3 50XP"
                mainView.todayGoalLabel3.text = "\(UserStats.stats[0])/5 70XP"
            }else if UserStats.stats[0] >= 1{
                mainView.tickBox.image = UIImage(systemName: "checkmark")
                mainView.todayGoalLabel.text = "1/1 20XP"
                mainView.todayGoalLabel2.text = "\(UserStats.stats[0])/3 50XP"
                mainView.todayGoalLabel3.text = "\(UserStats.stats[0])/5 70XP"
            }else{
                mainView.todayGoalLabel.text = "\(UserStats.stats[0])/1 20XP"
                mainView.todayGoalLabel2.text = "\(UserStats.stats[0])/3 50XP"
                mainView.todayGoalLabel3.text = "\(UserStats.stats[0])/5 70XP"
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
            mainView.closeView.addGestureRecognizer(tap)
            mainView.dailyQuizzesCompletedLabel.text = String(describing: UserStats.stats[0])
            mainView.dailyPointsEarnedLabel.text = String(describing: UserStats.stats[1])
            mainView.dailyWordsMasteredLabel.text = String(describing: UserStats.stats[2])
            mainView.weeklyQuizzesCompletedLabel.text = String(describing: UserStats.stats[3])
            mainView.weeklyPointsEarnedLabel.text = String(describing: UserStats.stats[4])
            mainView.weeklyWordsMasteredLabel.text = String(describing: UserStats.stats[5])
        }
    }
    
    @objc func close(sender:UIGestureRecognizer){
        dismiss(animated: true)
    }
}
