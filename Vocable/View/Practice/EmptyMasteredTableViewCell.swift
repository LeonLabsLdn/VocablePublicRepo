import UIKit

class EmptyMasteredTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let mainLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 317).isActive = true
        titleLabel.text = "Your mastered list is empty"
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = #colorLiteral(red: 0.5913596749, green: 0.5913595557, blue: 0.5913596153, alpha: 1)
        selectionStyle = .none
        mainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 14).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 69).isActive = true
        mainLabel.text = "Practice words in your study list and master them to start building your mastered words list"
        mainLabel.numberOfLines = 0
        mainLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        mainLabel.textAlignment = .center
        mainLabel.textColor = #colorLiteral(red: 0.5913596749, green: 0.5913595557, blue: 0.5913596153, alpha: 1)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
