//
//  LoginCoordinator.swift
//  mTask
//
//  Created by Tianhe Wang on 2/3/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import Google

import GoogleSignIn
import GoogleAPIClientForREST

class LoginCoordinator: NSObject {

  // MARK: Lifecycle

  init(presentingViewController: UIViewController) {
    self.presentingViewController = presentingViewController

    // Initialize sign-in
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
  }

  // MARK: Internal

  func startFlow(completion: @escaping ((_ user: GIDGoogleUser?) -> Void)) {
    // Configure Google Sign-in.
    GIDSignIn.sharedInstance().scopes = scopes

    signInViewController.didLogin = { [weak self] user, error in
      guard let strongSelf = self else { return }
      if let error = error {
        strongSelf.signInViewController.showAlert(title: "Authentication Error", message: error.localizedDescription)
        completion(nil)
      } else {
        strongSelf.presentingViewController.dismiss(animated: true) {
          completion(user)
        }
      }
    }
    presentingViewController.present(signInViewController, animated: true, completion: nil)
    GIDSignIn.sharedInstance().signInSilently()
  }

  // MARK: Private

  private var presentingViewController: UIViewController
  private let scopes = [kGTLRAuthScopeTasksReadonly]
  fileprivate let signInViewController = SignInViewController()
}
