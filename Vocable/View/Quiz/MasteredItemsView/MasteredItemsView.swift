import UIKit
import Lottie

class MasteredItemsView: UIView {

    let nibName = "MasteredItemsView"

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mainCard: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var masteredAmount: UILabel!
    static let shared = MasteredItemsView()
    var collectionView:UICollectionView?
    private var animationView: LottieAnimationView?
    let masteredItemsDelegate = MasteredItemsDelegate()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {guard let view = loadViewFromNib() else { return };view.frame = self.bounds;self.addSubview(view)
        mainCard.layer.cornerRadius = 10
        closeButton.layer.cornerRadius = closeButton.frame.size.height / 2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 117)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MasteredItemsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = masteredItemsDelegate
        collectionView?.dataSource = masteredItemsDelegate
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        mainCard.addSubview(collectionView ?? UICollectionView())
        collectionView?.frame = CGRect(x: 0, y: 99, width: UIScreen.main.bounds.width - 32, height: 117)
        animationView = .init(name: "confetti")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        closeButton.addTarget(self, action: #selector(closeView(sender:)), for: .touchUpInside)
    }

    func reloadDataView(){
        collectionView?.reloadData()
        masteredAmount.text = "You mastered \(UserData.masteredData.count) words"
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @objc func closeView(sender:UIButton){
        Protocols.practiceDelegate?.removeMasteredView()
    }
}


class MasteredItemsCollectionViewCell:UICollectionViewCell{
    let masteredItemsCell = MasteredItemsCell()
    override init(frame: CGRect){
        super .init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(masteredItemsCell)
        masteredItemsCell.frame = contentView.frame
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        super.awakeFromNib()
    }
}

