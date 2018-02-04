//
//  AppCoordinator.swift
//  mTask
//
//  Created by Tianhe Wang on 2/3/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {

  // MARK: Lifecycle

  init(window: UIWindow) {
    mainWindow = window
    super.init()
    initializeNavigation()
  }

  // MARK: Internal

  func startUp() {
    guard let rootViewController = mainWindow.rootViewController else { return }
    let loginCoordinator = LoginCoordinator(presentingViewController: rootViewController)
    loginCoordinator.startFlow()
    self.loginCoordinator = loginCoordinator
  }

  // MARK: Private

  private var mainWindow: UIWindow
  private var loginCoordinator: LoginCoordinator?

  private func initializeNavigation() {
    // set a black background for window
    mainWindow.backgroundColor = .black

    // set a red background for root view
    let rootViewController = UIViewController()
    rootViewController.view.backgroundColor = .red
    mainWindow.rootViewController = rootViewController

    mainWindow.makeKeyAndVisible()
  }
}
