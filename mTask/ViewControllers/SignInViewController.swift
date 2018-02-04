import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class SignInViewController: UIViewController, GIDSignInUIDelegate {

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
  }

  // MARK: Internal

  var didLogin: ((GIDGoogleUser, Error?) -> Void)?

  // Helper for showing an alert
  func showAlert(title : String, message: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: UIAlertControllerStyle.alert
    )
    let ok = UIAlertAction(
      title: "OK",
      style: UIAlertActionStyle.default,
      handler: nil
    )
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }

  // Mark: Private

  private let signInButton = GIDSignInButton()

  private func setUpViews() {
    // Add the sign-in button.
    view.addSubview(signInButton)
  }
}

extension SignInViewController: GIDSignInDelegate {

  func sign(_ signIn: GIDSignIn!,
            didSignInFor user: GIDGoogleUser!,
            withError error: Error!)
  {
    didLogin?(user, error)
  }
}
