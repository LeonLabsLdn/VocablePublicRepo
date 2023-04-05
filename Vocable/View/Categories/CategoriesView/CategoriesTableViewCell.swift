import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBottom: NSLayoutConstraint!
    
    @IBOutlet weak var cellTop: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesView: CategoriesView!
    
    override func layoutSubviews() {
        selectionStyle = .none;super.layoutSubviews();super.awakeFromNib();self.contentView.layoutIfNeeded()
    }
}
