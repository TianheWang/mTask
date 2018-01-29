import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {


  // If modifying these scopes, delete your previously saved credentials by
  // resetting the iOS simulator or uninstall the app.
  private let scopes = [kGTLRAuthScopeTasksReadonly]

  private let service = GTLRTasksService()
  let signInButton = GIDSignInButton()
  let output = UITextView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Configure Google Sign-in.
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().scopes = scopes
    GIDSignIn.sharedInstance().signInSilently()

    // Add the sign-in button.
    view.addSubview(signInButton)

    // Add a UITextView to display output.
    output.frame = view.bounds
    output.isEditable = false
    output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    output.isHidden = true
    view.addSubview(output);
  }

  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    if let error = error {
      showAlert(title: "Authentication Error", message: error.localizedDescription)
      self.service.authorizer = nil
    } else {
      self.signInButton.isHidden = true
      self.output.isHidden = false
      self.service.authorizer = user.authentication.fetcherAuthorizer()
      fetchTasks()
    }
  }

  // Construct a query to get a user's task lists using the Google Tasks API
  func fetchTasks() {
    output.text = "Getting task lists..."

    let query = GTLRTasksQuery_TasklistsList.query()
    query.maxResults = 10
    service.executeQuery(query,
                         delegate: self,
                         didFinish: #selector(fetchTasksInFirstList(ticket:finishedWithObject:error:))
    )
  }

  func fetchTasksInTaskList(taskList: String) {

    let query = GTLRTasksQuery_TasksList.query(withTasklist: taskList)
    query.maxResults = 10
    service.executeQuery(query,
                         delegate: self,
                         didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
    )
  }


  @objc func fetchTasksInFirstList(ticket: GTLRServiceTicket,
                                   finishedWithObject response : GTLRTasks_TaskLists,
                                   error : NSError?) {
    if let error = error {
      showAlert(title: "Error", message: error.localizedDescription)
      return
    }

    var outputText = ""

    if let taskLists = response.items, !taskLists.isEmpty {
      let taskList = taskLists.first
      if let id = taskList?.identifier {
        fetchTasksInTaskList(taskList: id)
      }
    } else {
      outputText = "No task lists found."
    }

//    output.text = outputText
  }


  // Process the response and display output
  @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                               finishedWithObject response : GTLRTasks_Tasks,
                               error : NSError?) {

    if let error = error {
      showAlert(title: "Error", message: error.localizedDescription)
      return
    }

    var outputText = ""

    if let taskList = response.items, !taskList.isEmpty {
      for task in taskList {
        // The API field "id" is renamed "identifier" in this library.
        outputText += "\(task.title ?? "") (\(task.due?.stringValue ?? ""))\n"
      }
    } else {
      outputText = "No task lists found."
    }

    output.text = outputText
  }


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
}
