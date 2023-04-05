import UIKit

class NonProView: UIView {
    
    let image = UIImageView(image: UIImage(named: "nonProPlaceholder"))
    let proButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(proButton)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
        proButton.adjustsImageWhenHighlighted = false
        proButton.translatesAutoresizingMaskIntoConstraints = false
        proButton.setTitle("Subscribe to Pro", for: .normal)
        proButton.setImage(UIImage(systemName:"shield.fill"), for: .normal)
        proButton.tintColor = #colorLiteral(red: 0.9243742824, green: 0.7168431878, blue: 0.2130913734, alpha: 1)
        proButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        proButton.sizeToFit()
        proButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        proButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        proButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        proButton.widthAnchor.constraint(equalToConstant: proButton.intrinsicContentSize.width + 72).isActive = true
        proButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)

    }
    
    override func layoutSubviews() {proButton.layer.cornerRadius = 27;proButton.backgroundColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)}

    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder)!;fatalError()}
}
