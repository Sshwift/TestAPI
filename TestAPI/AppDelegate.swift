import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tableVC = TableViewController()
        let navVC = UINavigationController(rootViewController: tableVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

