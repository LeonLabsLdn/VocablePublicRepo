import CoreData
import GoogleMobileAds
import AVKit
import Network
import GoogleSignIn
import FirebaseCore

@main

class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UserStats.streak = ["-","-","-","-","-","-","-"]
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if UserData.offline == true{
                    UserData.offline = false
                    NetworkModel.shared.retrieveProPractice()
                    Protocols.homeDelegate?.resetUserData()
                }
            }
        }
        monitor.start(queue:DispatchQueue(label: "Monitor"))
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "53ba7cf2b6011a0dd49adc95da8bb0e1" ]
        let RetrivedDate = UserDefaults.standard.object(forKey: "expiry") as? Date
        if RetrivedDate?.isInThePast == false{
            PurchaseModel.shared.isPro = true
        }
        PurchaseModel.shared.restoreFetch()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
        catch let error as NSError {
            print("Error: Could not set audio category: \(error), \(error.userInfo)")
        }
            return true
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LoginApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
