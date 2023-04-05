import UIKit
import Lottie

class LoadingAnimationView: UIView {
    
    static let shared = LoadingAnimationView()
    var animationView:LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animationView = .init(name: "loading.json")
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1
        self.frame.size.height = 80
        self.frame.size.width = 80
        layer.cornerRadius = 10
        animationView!.play()
        animationView!.frame = bounds.inset(by: UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5))
        addSubview(animationView!)
        backgroundColor = UIColor(white: 1, alpha: 0.9)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError()
    }
    
    override func layoutSubviews() {}
    
}
