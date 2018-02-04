//
//  LoginCoordinator.swift
//  mTask
//
//  Created by Tianhe Wang on 2/3/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import Google
import GoogleAPIClientForREST
import GoogleSignIn

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

  func startFlow() {
    // Configure Google Sign-in.
    GIDSignIn.sharedInstance().scopes = scopes

    signInViewController.didLogin = { [weak self] user, error in
      guard let strongSelf = self else { return }
      if let error = error {
        strongSelf.signInViewController.showAlert(title: "Authentication Error", message: error.localizedDescription)
        strongSelf.service.authorizer = nil
      } else {
        strongSelf.signInViewController.showAlert(title: "Authentication success", message: "")
        strongSelf.service.authorizer = user.authentication.fetcherAuthorizer()
//        strongSelf.fetchTasks()
      }
    }
    presentingViewController.present(signInViewController, animated: true, completion: nil)
    GIDSignIn.sharedInstance().signInSilently()
  }

  // MARK: Private

  private var presentingViewController: UIViewController
  private let scopes = [kGTLRAuthScopeTasksReadonly]
  fileprivate let service = GTLRTasksService()
  fileprivate let signInViewController = SignInViewController()

//
//  // Construct a query to get a user's task lists using the Google Tasks API
//  private func fetchTasks() {
//    // to do: show full page loading
////    output.text = "Getting task lists..."
//
//    let query = GTLRTasksQuery_TasklistsList.query()
//    query.maxResults = 10
//    service.executeQuery(query,
//                         delegate: self,
//                         didFinish: #selector(fetchTasksInFirstList(ticket:finishedWithObject:error:))
//    )
//  }
//
//  private func fetchTasksInTaskList(taskList: String) {
//
//    let query = GTLRTasksQuery_TasksList.query(withTasklist: taskList)
//    query.maxResults = 10
//    service.executeQuery(query,
//                         delegate: self,
//                         didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
//    )
//  }
//
//  @objc func fetchTasksInFirstList(ticket: GTLRServiceTicket,
//                                   finishedWithObject response : GTLRTasks_TaskLists,
//                                   error : NSError?) {
//    if let error = error {
////      showAlert(title: "Error", message: error.localizedDescription)
//      return
//    }
//
//    var outputText = ""
//
//    if let taskLists = response.items, !taskLists.isEmpty {
//      let taskList = taskLists.first
//      if let id = taskList?.identifier {
//        fetchTasksInTaskList(taskList: id)
//      }
//    } else {
//      outputText = "No task lists found."
//    }
//
//    //    output.text = outputText
//  }
//
//
//  // Process the response and display output
//  @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
//                                     finishedWithObject response : GTLRTasks_Tasks,
//                                     error : NSError?) {
//
//    if let error = error {
////      showAlert(title: "Error", message: error.localizedDescription)
//      return
//    }
//
//    var outputText = ""
//
//    if let taskList = response.items, !taskList.isEmpty {
//      for task in taskList {
//        // The API field "id" is renamed "identifier" in this library.
//        outputText += "\(task.title ?? "") (\(task.due?.stringValue ?? ""))\n"
//      }
//      print(outputText)
//    } else {
//      outputText = "No task lists found."
//    }
//
////    output.text = outputText
//  }


}
