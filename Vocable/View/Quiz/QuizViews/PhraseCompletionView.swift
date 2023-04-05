import UIKit

class PhraseCompletionView: UIView {
    
    static let shared = PhraseCompletionView()
    let qView = UIView()
    let lineView = UIView()
    let lineView1 = UIView()
    let lineView2 = UIView()
    let ukIcon = UIImageView(image: UIImage(named: "ukIcon"))
    let qLabel = UILabel()
    let screenRect = UIScreen.main.bounds
    var collectionView1:UICollectionView?
    var collectionView2:UICollectionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadView()
    }
    
    func loadView(){
        let screenWidth = screenRect.size.width
        
        //Question and answer view
        qView.translatesAutoresizingMaskIntoConstraints = false
        qLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        qLabel.textColor = .black
        let views = [ukIcon,qLabel]
        for views in views{qView.addSubview(views)}
        addSubview(qView)
        qView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        qView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0).isActive = true
        qView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        ukIcon.translatesAutoresizingMaskIntoConstraints = false
        ukIcon.leftAnchor.constraint(equalTo: qView.leftAnchor,constant: 16).isActive = true
        ukIcon.topAnchor.constraint(equalTo: qView.topAnchor,constant: 19).isActive = true
        ukIcon.heightAnchor.constraint(equalToConstant: 14).isActive = true
        ukIcon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        ukIcon.contentMode = .scaleAspectFit
        qLabel.translatesAutoresizingMaskIntoConstraints = false
        qLabel.leftAnchor.constraint(equalTo: ukIcon.rightAnchor, constant: 8).isActive = true
        qLabel.topAnchor.constraint(equalTo: qView.topAnchor,constant: 16).isActive = true
        qLabel.rightAnchor.constraint(equalTo: qView.rightAnchor,constant: -16).isActive = true
        qLabel.bottomAnchor.constraint(equalTo: qView.bottomAnchor,constant: -16).isActive = true
        qLabel.numberOfLines = 0
       
        //AnswerCollectionView
        let layout: UICollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 20)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView1?.translatesAutoresizingMaskIntoConstraints = false
        collectionView1?.backgroundColor = .clear
        collectionView1?.showsHorizontalScrollIndicator = false
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        addSubview(collectionView1 ?? UICollectionView())
        collectionView1?.leftAnchor.constraint(equalTo: leftAnchor, constant: 0.0).isActive = true
        collectionView1?.rightAnchor.constraint(equalTo: rightAnchor, constant: 0.0).isActive = true
        collectionView1?.topAnchor.constraint(equalTo: qView.bottomAnchor, constant: 4.0).isActive = true
        collectionView1?.bottomAnchor.constraint(equalTo: qView.bottomAnchor, constant: 174).isActive = true
        let lvs = [lineView,lineView1,lineView2]
        for lv in lvs{
            lv.layer.borderWidth = 1
            lv.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)}
        lineView.frame = CGRect(x: 16, y: 63, width: screenWidth - 32, height: 1)
        lineView1.frame = CGRect(x: 16, y: 116, width: screenWidth - 32, height: 1)
        lineView2.frame = CGRect(x: 16, y: 169, width: screenWidth - 32, height: 1)
        collectionView1?.addSubview(lineView)
        collectionView1?.addSubview(lineView1)
        collectionView1?.addSubview(lineView2)
        collectionView1?.register(CompletePhraseCell.self, forCellWithReuseIdentifier: "completioncell")
        collectionView1?.dragInteractionEnabled = true
        collectionView1?.delegate = QuizDelegate.shared
        collectionView1?.dataSource = QuizDelegate.shared
        
        //SelectionCollectionview
        let layout2: UICollectionViewFlowLayout = UICollectionViewCenterLayout()
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 20)
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        collectionView2?.translatesAutoresizingMaskIntoConstraints = false
        collectionView2?.showsHorizontalScrollIndicator = false
        layout2.minimumLineSpacing = 8
        layout2.scrollDirection = .vertical
        addSubview(collectionView2 ?? UICollectionView())
        collectionView2?.leftAnchor.constraint(equalTo: leftAnchor, constant: 0.0).isActive = true
        collectionView2?.rightAnchor.constraint(equalTo: rightAnchor, constant: 0.0).isActive = true
        collectionView2?.topAnchor.constraint(equalTo: collectionView1!.bottomAnchor, constant: 32.0).isActive = true
        collectionView2?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        collectionView2?.register(CompletePhraseCell.self, forCellWithReuseIdentifier: "completioncell")
        collectionView2?.delegate = QuizDelegate.shared
        collectionView2?.dataSource = QuizDelegate.shared
        collectionView2?.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.awakeFromNib()
        qView.layer.cornerRadius = 8
        qView.layer.borderWidth = 4
        qView.layer.borderColor = #colorLiteral(red: 0.8941177726, green: 0.8941176534, blue: 0.894117713, alpha: 1)
        qView.layer.masksToBounds = false
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}


class CollectionViewRow {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0
    init(spacing: CGFloat) {self.spacing = spacing}
    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }
    var rowWidth: CGFloat {
        return attributes.reduce(0, { result, attribute -> CGFloat in
            return result + attribute.frame.width
        }) + CGFloat(attributes.count - 1) * spacing
    }
    func centerLayout(collectionViewWidth: CGFloat) {
        let padding = (collectionViewWidth - rowWidth) / 2
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
}

class UICollectionViewCenterLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var rows = [CollectionViewRow]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.midY {
                currentRowY = attribute.frame.midY
                rows.append(CollectionViewRow(spacing: 10))
            }
            rows.last?.add(attribute: attribute)
        }
        rows.forEach { $0.centerLayout(collectionViewWidth: collectionView?.frame.width ?? 0) }
        return rows.flatMap { $0.attributes }
    }
}
