import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {return}
        print(firstUrl)
        print("vocable://\(UserData.vcode ?? "")")
        if firstUrl == URL(string: "vocable://\(UserData.vcode ?? "")"){
            if UserData.exists != true{
                if UserData.loginVC == true{
                    Protocols.loginVCDelegate?.segueToLanguages(email: UserData.email!, password: UserData.password!, name: "-")
                }else{
                    Protocols.landingDelegate?.segueToLanguages(email: UserData.email!, password: UserData.password!, name: "-")
                }
            }else{
                do{
                    try Keychain.shared.addcreds(username: UserData.email!, password: UserData.password!)
                    if UserData.loginVC == true{
                        Protocols.loginVCDelegate?.login(email: UserData.email!, name: "-", password: UserData.password!)
                    }else{
                        Protocols.landingDelegate?.linkLogin(email: UserData.email!, name: "-", password: UserData.password!)
                    }
                }catch{
                    UserData.password = ""
                    UserData.email = ""
                    if UserData.loginVC == true{
                        Protocols.loginVCDelegate?.loginError()
                    }else{
                        Protocols.landingDelegate?.loginError()
                    }
                }
            }
        }else{
            //
            Protocols.loginVCDelegate?.loginError()
            Protocols.landingDelegate?.loginError()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if UserData.imageRecognitionActive{
            Protocols.imageRecognitionDelegate?.startRunning()
        }
        if UserData.id != 0 && UserData.isPurchasing != true{
            Protocols.homeDelegate?.resetUserData()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        Protocols.imageRecognitionDelegate?.stopRunning()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

