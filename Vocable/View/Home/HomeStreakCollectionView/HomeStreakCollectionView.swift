import UIKit

class HomeStreakCollectionView:UIView{
    
    static let shared = HomeStreakCollectionView()
    var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 87)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 42, height: 60.5)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 87), collectionViewLayout: layout)
        collectionView?.register(HomeStreakCollectionViewCell.self, forCellWithReuseIdentifier: "streakCell")
        collectionView?.dataSource = HomeStreakDelegate.shared
        collectionView?.delegate = HomeStreakDelegate.shared
        layout.minimumLineSpacing = 16
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isScrollEnabled = false
        collectionView?.backgroundColor = #colorLiteral(red: 0.6296007037, green: 0.8165065646, blue: 0.7117897868, alpha: 1)
        addSubview(collectionView ?? UICollectionView())}
    
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder)!;fatalError()}
}

class HomeStreakCollectionViewCell:UICollectionViewCell{
    let roundView = UIView()
    let pointsLabel = UILabel()
    let dailyStreakImage = UIImageView()
    let dayLabel = UILabel()

    override init(frame: CGRect){
        super .init(frame: frame)
        roundView.frame = CGRect(x: 1, y: 1, width: 40, height: 40)
        contentView.addSubview(roundView)
        roundView.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        dayLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
        dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7.0).isActive = true
        roundView.addSubview (dailyStreakImage)
        dailyStreakImage.frame = CGRect(x: 14, y: 21, width: 12, height: 12)
        dailyStreakImage.contentMode = .scaleAspectFit
        contentView.addSubview(pointsLabel)
        pointsLabel.frame = CGRect(x: 0, y: 45, width: 42, height: 15.5)
        pointsLabel.textAlignment = .center}
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
