
import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var masteredView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var barView: UIProgressView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var percentageMasteredLabel: UILabel!
    @IBOutlet weak var wordsMasteredLabel: UILabel!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var masteredTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
