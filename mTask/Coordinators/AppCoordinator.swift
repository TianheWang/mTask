//
//  AppCoordinator.swift
//  mTask
//
//  Created by Tianhe Wang on 2/3/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import UIKit

import GoogleSignIn

class AppCoordinator: NSObject {

  // MARK: Lifecycle

  init(window: UIWindow) {
    mainWindow = window
    super.init()
    initializeNavigation()
  }

  // MARK: Internal

  func startUp() {
    guard let rootViewController = rootViewController else { return }
    let loginCoordinator = LoginCoordinator(presentingViewController: rootViewController)
    loginCoordinator.startFlow { [weak self] user in
      guard let user = user else {
        // handle login error
        return
      }
      self?.didLogin(for: user)
      print("loggin success")
    }
    self.loginCoordinator = loginCoordinator
  }

  // MARK: Private

  private var mainWindow: UIWindow
  private var loginCoordinator: LoginCoordinator?
  private var tasksCoordinator: TasksCoordinator?
  private var rootViewController: UIViewController? {
    return mainWindow.rootViewController
  }

  private func initializeNavigation() {
    // set a black background for window
    mainWindow.backgroundColor = .black

    // set a red background for root view
    let rootViewController = UIViewController()
    rootViewController.view.backgroundColor = .red
    mainWindow.rootViewController = rootViewController

    mainWindow.makeKeyAndVisible()
  }

  private func didLogin(for user: GIDGoogleUser) {
    guard let rootViewController = rootViewController else { return }
    tasksCoordinator = TasksCoordinator(user: user, presentingViewController: rootViewController)
    tasksCoordinator?.startFlow()
  }
}
