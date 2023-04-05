import UIKit

class EmptyListTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let mainLabel = UILabel()
    let generateButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 317).isActive = true
        titleLabel.text = "Your study list is empty"
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = #colorLiteral(red: 0.5913596749, green: 0.5913595557, blue: 0.5913596153, alpha: 1)
        selectionStyle = .none
        mainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 14).isActive = true
        mainLabel.widthAnchor.constraint(equalToConstant: 317).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 69).isActive = true
        mainLabel.text = "Browse categories to add words to your study list, alternatively let us generate a random study list for you.."
        mainLabel.numberOfLines = 0
        mainLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        mainLabel.textAlignment = .center
        mainLabel.textColor = #colorLiteral(red: 0.5913596749, green: 0.5913595557, blue: 0.5913596153, alpha: 1)
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        config.baseBackgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        config.contentInsets.trailing = 40
        config.contentInsets.leading = 40
        config.contentInsets.top = 16
        config.contentInsets.bottom = 16
        config.attributedTitle = AttributedString("Generate random", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 20)!]))
        config.cornerStyle = .capsule
        config.attributedTitle?.foregroundColor = .white
        generateButton.configuration = config
        generateButton.isUserInteractionEnabled = true
        generateButton.titleLabel?.lineBreakMode = .byWordWrapping
        generateButton.sizeToFit()
        generateButton.layer.cornerRadius = generateButton.frame.height / 2
        generateButton.addTarget(self, action: #selector(randomPick(_:)), for: .touchUpInside)
        contentView.addSubview(generateButton)
        generateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        generateButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 30).isActive = true
        generateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    @objc func randomPick(_:Any){
        Protocols.practiceDelegate?.addLoading()
        NetworkModel.shared.generateProList()
    }
}
