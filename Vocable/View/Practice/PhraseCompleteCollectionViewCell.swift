import UIKit

class CompletePhraseCell:UICollectionViewCell{
    
    let label = UILabel()
    
    override init(frame: CGRect){
        super .init(frame: frame)
        label.numberOfLines = 1
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.textColor = .black
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.awakeFromNib()
        layer.borderWidth = 4
        layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
        layer.cornerRadius = 8
    }
}
