import UIKit

class ProContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: StudyListCellView!
    
    override func layoutSubviews() {
        selectionStyle = .none
        super.layoutSubviews()
        super.awakeFromNib()
        self.contentView.layoutIfNeeded()
    }
}

