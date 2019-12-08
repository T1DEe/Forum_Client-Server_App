
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var currentUser: User?
    var window: UIWindow?

    var navigationVC: UINavigationController? 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor.hexStringToUIColor(hex: "#0096FF")
        UINavigationBar.appearance().tintColor = .white
        
//        currentUser = User(id: 20, username: "testuser1")
        
        return true
    }

}

