//
//  TasksCoordinator.swift
//  mTask
//
//  Created by Tianhe Wang on 1/28/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation

import GoogleSignIn

class TasksCoordinator {

  // MARK: Lifecycle

  init(user: GIDGoogleUser, presentingViewController: UIViewController) {
    tasksDataSource = TasksDataSource(user: user)
    self.presentingViewController = presentingViewController
  }

  // MARK: Internal

  func startFlow() {
    let tasksViewController = TasksViewController(dataSource: tasksDataSource)
    let loadingViewController = UIViewController()
    loadingViewController.view.backgroundColor = .blue
    presentingViewController?.present(loadingViewController, animated: true, completion: nil)
    tasksDataSource.fetchAllTasks { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.presentingViewController?.dismiss(animated: true) {
        strongSelf.presentingViewController?.present(tasksViewController, animated: true, completion: nil)
      }
    }
    self.tasksViewController = tasksViewController
  }

  // MARK: Private
  private var tasksDataSource: TasksDataSource
  private var tasksViewController: TasksViewController?
  private var presentingViewController: UIViewController?
}
