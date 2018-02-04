//
//  TasksViewController.swift
//  mTask
//
//  Created by Tianhe Wang on 1/28/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import UIKit

class TasksViewController: UIViewController {

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpTableView()
  }

  // MARK: Private
  private var tableView = UITableView()
  fileprivate var dummyData = ["Line 1", "Line 2", "Line 3"]
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
    print("Value: \(dummyData[indexPath.row])")
  }
}

extension TasksViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dummyData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
    cell.textLabel?.text = "\(dummyData[indexPath.row])"
    return cell
  }
}
