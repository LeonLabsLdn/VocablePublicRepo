import UIKit

class StartTableViewCell:UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let startButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        config.baseBackgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        config.contentInsets.trailing = 40
        config.contentInsets.leading = 40
        config.contentInsets.top = 16
        config.contentInsets.bottom = 16
        config.attributedTitle = AttributedString("Start practice", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 20)!,NSAttributedString.Key.foregroundColor : UIColor.white]))
        config.cornerStyle = .capsule
        startButton.configuration = config
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.isUserInteractionEnabled = true
        startButton.titleLabel?.lineBreakMode = .byWordWrapping
        startButton.sizeToFit()
        contentView.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        startButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8).isActive = true
        selectionStyle = .none
        startButton.addTarget(self, action: #selector(fu(_:)), for: .touchUpInside)
        startButton.isUserInteractionEnabled = true
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func fu (_:Any){
        Protocols.practiceDelegate?.startQuiz(cat: "", isPro: true)
    }
}
