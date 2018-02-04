//
//  TasksViewController.swift
//  mTask
//
//  Created by Tianhe Wang on 1/28/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import UIKit

// TODO: create own task model
import GoogleAPIClientForREST

class TasksViewController: UIViewController {

  // MARK: Lifecycle
  init(dataSource: TasksDataSource) {
    super.init(nibName: nil, bundle: nil)
    self.dataSource = dataSource
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableView()
    tasks = dataSource?.allTasks() ?? []
  }

  // MARK: Private
  private var tableView = UITableView()
  fileprivate var dataSource: TasksDataSource?
  fileprivate var tasks: [GTLRTasks_Task] = []
  fileprivate let cellId = "cellId"

  private func setUpTableView() {
    view.addSubview(tableView)
    setUpTableViewConstraints()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.delegate = self
    tableView.dataSource = self
  }

  private func setUpTableViewConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.constrainTo(parentView: view)
  }
}

extension TasksViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Num: \(indexPath.row)")
    print("Value: \(tasks[indexPath.row])")
  }
}

extension TasksViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
    cell.textLabel?.text = "\(tasks[indexPath.row].title ?? "")"
    return cell
  }
}
