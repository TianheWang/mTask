//
//  TasksDataSource.swift
//  mTask
//
//  Created by Tianhe Wang on 2/3/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation

import GoogleAPIClientForREST
import GoogleSignIn

class TasksDataSource {

  // MARK: Lifecycle

  init(user: GIDGoogleUser) {
    service.authorizer = user.authentication.fetcherAuthorizer()
  }

  // MARK: Internal

  func allTasks() -> [GTLRTasks_Task] {
    var result: [GTLRTasks_Task] = []
    for (_, tasksInList) in tasks {
      guard let tasksInList = tasksInList?.items, !tasksInList.isEmpty else { continue }
      result.append(contentsOf: tasksInList)
    }
    return result
  }

  func fetchAllTasks(completion: @escaping () -> Void) {
    fetchTaskLists { [weak self] in
      guard let strongSelf = self,
        let taskLists = strongSelf.taskLists?.items,
        !taskLists.isEmpty
        else {
          return
      }

      let dispatchGroup = DispatchGroup()

      for taskList in taskLists {
        if let id = taskList.identifier {
          dispatchGroup.enter()
          strongSelf.fetchTasksInTaskList(taskListId: id) {
            dispatchGroup.leave()
          }
        }
      }

      dispatchGroup.notify(queue: .main) {
        completion()
      }
    }
  }

  // MARK: Private

  private let MAX_LISTS: Int64 = 10
  private let service = GTLRTasksService()
  private var taskLists: GTLRTasks_TaskLists?
  private var tasks: [String: GTLRTasks_Tasks?] = [:]

  // Construct a query to get a user's task lists using the Google Tasks API
  private func fetchTaskLists(completion: @escaping (() -> Void)) {

    let query = GTLRTasksQuery_TasklistsList.query()
    query.maxResults = MAX_LISTS

    service.executeQuery(query) { [weak self] ticket, taskLists, error in
      guard let strongSelf = self else { return }

      if let error = error {
        // TODO: handle error
      } else {
        guard let taskLists = taskLists as? GTLRTasks_TaskLists else { return }
        strongSelf.taskLists = taskLists
        completion()
      }
    }
  }

  private func fetchTasksInTaskList(taskListId: String, completion: @escaping () -> Void) {
    let query = GTLRTasksQuery_TasksList.query(withTasklist: taskListId)

    service.executeQuery(query) { [weak self] ticket, tasks, error in
      guard let strongSelf = self else { return }

      if let error = error {
        // TODO: handle error
      } else {
        guard let tasks = tasks as? GTLRTasks_Tasks else { return }
        strongSelf.tasks[taskListId] = tasks
        completion()
      }
    }
  }
}
