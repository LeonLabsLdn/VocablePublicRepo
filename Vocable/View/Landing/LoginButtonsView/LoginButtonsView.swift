import UIKit
import AuthenticationServices

class LoginButtonsView: UIView {
    
    @IBOutlet weak var appleButton: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    let nibName = "LoginButtonsView"
    
    let authButtonType: Int = ASAuthorizationAppleIDButton.ButtonType.default.rawValue
    
    let authButtonStyle: Int = ASAuthorizationAppleIDButton.Style.black.rawValue
    
    required init?(
        coder aDecoder: NSCoder) {super.init(coder: aDecoder);commonInit()
            
        }
    override init(frame: CGRect) {super.init(frame: frame);commonInit()}
    func commonInit() {guard
        let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view);
        loginButton.layer.cornerRadius = 26.5
        googleButton.layer.cornerRadius = 26.5
        let type = ASAuthorizationAppleIDButton.ButtonType.continue
        googleButton.layer.borderColor = #colorLiteral(red: 0.628931284, green: 0.04916673899, blue: 0, alpha: 1)
        googleButton.layer.borderWidth = 2
        let style = ASAuthorizationAppleIDButton.Style.init(rawValue: authButtonStyle) ?? .black
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
        authorizationButton.cornerRadius = loginButton.frame.size.height / 2
        authorizationButton.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 53)
        authorizationButton.addTarget(self, action: #selector(appleLogin(_:)), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLogin(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        appleButton.addSubview(authorizationButton)}
    
    func loadViewFromNib() -> UIView? {let nib = UINib(nibName: nibName, bundle: nil);return nib.instantiate(withOwner: self, options: nil).first as? UIView}
    
    @objc func appleLogin(_:Any){
        
        if LoginModel.shared.appleLogin(self) == false{
            Protocols.landingDelegate?.landOffline()
        }
    }
    @objc func googleLogin(_:Any){Protocols.landingDelegate?.googleLogin()}
    @objc func login(_:Any){Protocols.landingDelegate?.relogin()}
}
