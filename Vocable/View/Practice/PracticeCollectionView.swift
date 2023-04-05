import UIKit

class PracticeCollectionView{
    
    static let shared = PracticeCollectionView()
    
    let collectionView: UICollectionView = {
        let cellSize = UIScreen.main.bounds.size.width / 2 - 24
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(PracticeCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.isHidden = false
        return collectionView
    }()
}

class PracticeCell:UICollectionViewCell{
    
    let icon = UIImageView()
    let ukIcon = UIImageView()
    let itaIcon = UIImageView()
    let ukLabel = UILabel()
    let itaLabel = UILabel()
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect){
        super .init(frame: frame)
        icon.frame = CGRect(x: 20, y: 10, width: 110, height: 75)
        ukIcon.frame = CGRect(x: 10, y: 100, width: 14, height: 14)
        itaIcon.frame = CGRect(x: 10, y: 121, width: 14, height: 14)
        ukLabel.frame = CGRect(x: 36, y: 100, width: 104, height: 19)
        itaLabel.frame = CGRect(x: 36, y: 121, width: 104, height: 25)
        ukLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        itaLabel.font = UIFont(name: "Roboto-Bold", size: 21)
        ukLabel.textColor = #colorLiteral(red: 0.4078493714, green: 0.4078375101, blue: 0.4078397155, alpha: 1)
        ukIcon.image = UIImage(named: "ukIcon")
        icon.contentMode = .scaleAspectFit
        ukIcon.contentMode = .scaleAspectFit
        itaIcon.contentMode = .scaleAspectFit
        backgroundColor = .white
        contentView.addSubview(ukLabel)
        contentView.addSubview(itaLabel)
        contentView.addSubview(ukIcon)
        contentView.addSubview(itaIcon)
        contentView.addSubview(icon)
        icon.center.x = contentView.center.x
        ukIcon.center.y = ukLabel.center.y
        itaIcon.center.y = itaLabel.center.y
        ukLabel.adjustsFontSizeToFitWidth = true
        itaLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
    }
}
