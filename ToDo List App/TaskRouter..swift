//
//  TaskRouter..swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation
import SwiftUI


struct TaskModuleBuilder {
    static func createModule() -> some View {
        let interactor = TaskInteractor()
        let router = TaskRouter()
        let presenter = TaskPresenter(interactor: interactor, router: router)
        
        return ContentView(presenter: presenter)
    }
}


final class TaskRouter: ObservableObject {
    @Published var showTaskDetail = false
    var selectedTask: TaskEntity?

    func navigateToTaskDetail(task: TaskEntity) {
        selectedTask = task
        showTaskDetail = true
    }
}
