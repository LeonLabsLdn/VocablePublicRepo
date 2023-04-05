
import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subCategoryView: SubCategoryView!
    
    override func layoutSubviews() {
        selectionStyle = .none;super.layoutSubviews();super.awakeFromNib();self.contentView.layoutIfNeeded()
    }
}
