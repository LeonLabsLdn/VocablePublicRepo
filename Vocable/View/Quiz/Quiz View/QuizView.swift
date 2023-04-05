import UIKit

class QuizView: UIView {

    let nibName = "QuizView"
    @IBOutlet weak var closeButton      : UIButton!
    @IBOutlet weak var quizButton       : UIButton!
    @IBOutlet weak var livesView        : LivesBarView!
    @IBOutlet weak var instructionLabel : UILabel!
    @IBOutlet weak var progressBar      : UIProgressView!
    @IBOutlet weak var wordMatchView    : UIView!
    @IBOutlet weak var textField        : UITextField!
    @IBOutlet weak var translateLabel   : UILabel!
    @IBOutlet weak var translateQView   : UIView!
    @IBOutlet weak var translateAView   : UIView!
    @IBOutlet weak var solutionView: UIView!
    
    @IBOutlet weak var learningIcon: UIImageView!
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        learningIcon.image = UIImage(named: UserData.lang)
        
        quizButton.layer.cornerRadius = quizButton.frame.size.height / 2
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2.5)
        progressBar.layer.cornerRadius = progressBar.frame.size.height / 2
        weak var wcv = WordMatchCollectionView.shared.collectionViewMethod()
        wordMatchView.addSubview(wcv!)
        wcv!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 450)
        PhraseCompletionView.shared.removeFromSuperview()
        view.addSubview(PhraseCompletionView.shared)
        PhraseCompletionView.shared.translatesAutoresizingMaskIntoConstraints = false
        PhraseCompletionView.shared.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        PhraseCompletionView.shared.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        PhraseCompletionView.shared.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16).isActive = true
        PhraseCompletionView.shared.bottomAnchor.constraint(equalTo: quizButton.topAnchor,constant: -16).isActive = true
        closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        textField.borderStyle = .none
        translateQView.layer.cornerRadius = 10
        translateAView.layer.cornerRadius = 10
        translateQView.layer.borderColor = #colorLiteral(red: 0.9560906291, green: 0.9364514947, blue: 0.9570348859, alpha: 1)
        translateQView.layer.borderWidth = 4
}

    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
    @objc func dismiss(_:Any){Protocols.quizProtocol?.quitQuiz()}
}


class WordMatchCollectionView{
    static let shared = WordMatchCollectionView()
    var collectionView:UICollectionView?
    func collectionViewMethod()->UICollectionView{
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 24, height: 71)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(WordMatchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = QuizDelegate.shared
        collectionView?.dataSource = QuizDelegate.shared
        return collectionView ?? UICollectionView()}
}

class WordMatchCollectionViewCell:UICollectionViewCell{
    let answerLabel = UILabel()
    override init(frame: CGRect){
        super .init(frame: frame)
        answerLabel.frame = CGRect(x: 8, y: 0, width: contentView.frame.size.width - 16, height: contentView.frame.size.height)
        answerLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        answerLabel.textAlignment = .center
        answerLabel.adjustsFontSizeToFitWidth = true
        backgroundColor = .white
        contentView.addSubview(answerLabel)}
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    override func layoutSubviews() {super.layoutSubviews();super.awakeFromNib();layer.cornerRadius = 8}
}
