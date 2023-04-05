import UIKit

class CategoryPhrasesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: SharedCardView?
    
    func test(){
        cardView?.spinner.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.awakeFromNib()
        self.contentView.layoutIfNeeded()
    }
}

