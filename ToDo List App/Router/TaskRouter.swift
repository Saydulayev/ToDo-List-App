//
//  TaskRouter..swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation

final class TaskRouter: TaskRouterProtocol {
    @Published var showTaskDetail = false
    var selectedTask: TaskEntity?

    func navigateToTaskDetail(task: TaskEntity) {
        selectedTask = task
        showTaskDetail = true
    }
}
