import Foundation
import UIKit

class ImagePlaceholderView:UIView{
    
    static let shared       = ImagePlaceholderView()
    let placeHolderImage    = UIImageView(image: UIImage(named:"cameraPlaceholder"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeHolderImage)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;fatalError()
    }
}
