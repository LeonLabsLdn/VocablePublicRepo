import UIKit

class HomeQuizCollectionView:UIView{

    let screenRect = UIScreen.main.bounds
    var collectionView:UICollectionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let screenWidth = screenRect.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 186), collectionViewLayout: layout)
        collectionView?.register(PracticeCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.dataSource = HomePracticeDelegate.shared
        collectionView?.delegate = HomePracticeDelegate.shared
        collectionView?.backgroundColor = .clear
        collectionView?.showsHorizontalScrollIndicator = false
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        addSubview(collectionView ?? UICollectionView())
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError()
    }

}
