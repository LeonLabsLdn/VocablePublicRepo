import UIKit

class HomeProView: UIView {
    
    let nibName = "HomeProView"
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var proRocketTop: NSLayoutConstraint!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var goProButton: UIButton!
    @IBOutlet weak var proRocket: UIImageView!
    @IBOutlet weak var proButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var proButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var proButtonLeft: NSLayoutConstraint!
    @IBOutlet weak var proButtonTop: NSLayoutConstraint!
    @IBOutlet var mainView: UIView!
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()}
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        mainView.layer.cornerRadius = 10
        goProButton.layer.cornerRadius = proButtonHeight.constant / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeButtonFunc(_:)))
        view.addGestureRecognizer(tap)
//        closeButton.addTarget(self, action: #selector(closeButtonFunc(_:)), for: .touchUpInside)

    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @objc func closeButtonFunc(_:Any){
        let compress: [CGFloat] = [-250,16,16,24,88,12,-4,0,12,0.8,56,0]
        let expand:[CGFloat] = [16,48,131,55,166,20,-10,1,27.5,1,162,102]
        var values:[CGFloat]?
        var imageString:String?
        if closeButton.imageView?.image != UIImage(systemName: "chevron.down"){
            values = compress
            imageString = "chevron.down"
        }else{
            values = expand;imageString = "xmark"
        }
        Protocols.homeDelegate?.homeContentHeight(amount: values![10])
        proRocketTop.constant = values![0]
        proButtonTop.constant = values![1]
        proButtonLeft.constant = values![2]
        proButtonHeight.constant = values![3]
        proButtonWidth.constant = values![4]
        goProButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: values![5])
        closeButton.setImage(UIImage(systemName: imageString!), for: .normal)
        UIView.animate(withDuration: 0.3, animations: { [self] in
            Protocols.homeDelegate?.homeLayoutSubview()
            layoutSubviews()
            mainView.layoutSubviews()
            goProButton.layoutSubviews()
            goProButton.titleLabel?.layoutSubviews()
            proRocket.layer.opacity = Float(values![7])
            goProButton.layer.cornerRadius = values![8]
            goProButton.imageView?.layer.transform = CATransform3DMakeScale(values![9], values![9], values![9])})
        UIView.animate(withDuration: 0.2, animations: { [self] in
            monthLabel.layer.opacity = Float(values![7])
            yearLabel.layer.opacity = Float(values![7])
            goProButton.imageEdgeInsets.right = 8
            closeButton.layoutSubviews()
        })
    }
}
