import UIKit

import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
  {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let appCoordinator = AppCoordinator(window: window)
    appCoordinator.startUp()
    self.window = window
    self.appCoordinator = appCoordinator

    return true
  }

  func application(_ application: UIApplication,
                   open url: URL, sourceApplication: String?, annotation: Any) -> Bool
  {
    return GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
  }

  @available(iOS 9.0, *)
  func application(_ app: UIApplication, open url: URL,
                   options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
  {
    let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
    let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
    return GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
  }

}
