//
//  TaskPresenter.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation

final class TaskPresenter: TaskPresenterProtocol, ObservableObject {
    @Published var tasks: [TaskEntity] = []
    private let interactor: TaskInteractorProtocol
    let router: TaskRouter // Теперь презентер содержит роутер

    private enum Constants {
        static let userDefaultsKey = "hasLoadedTasksFromAPI"
    }
    
    
    init(interactor: TaskInteractorProtocol, router: TaskRouter) {
        self.interactor = interactor
        self.router = router
        loadTasks()
    }
    

    func loadTasks() {
        let hasLoadedTasksFromAPI = UserDefaults.standard.bool(forKey: Constants.userDefaultsKey)
        
        if hasLoadedTasksFromAPI {
            interactor.fetchTasks { [weak self] tasks in
                DispatchQueue.main.async {
                    self?.tasks = tasks
                }
            }
        } else {
            interactor.fetchTasksFromAPI { [weak self] tasks in
                DispatchQueue.main.async {
                    self?.tasks = tasks
                    UserDefaults.standard.set(true, forKey: Constants.userDefaultsKey)
                }
            }
        }
    }

    func addTask(title: String, details: String, completion: @escaping (Bool) -> Void) {
        interactor.addTask(title: title, details: details, onSuccess: { [weak self] in
            self?.loadTasks()
            completion(true)
        }, onFailure: { error in
            completion(false)
        })
    }
    

    func toggleTaskCompletion(task: TaskEntity) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()

        interactor.updateTask(task: updatedTask, onSuccess: { [weak self] in
            guard let self = self else { return }
            
            if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                self.tasks[index] = updatedTask
            }

            self.loadTasks()
        }, onFailure: { error in
            print("Failed to toggle task completion: \(error?.localizedDescription ?? "Unknown error")")
        })
    }


    func updateTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        interactor.updateTask(task: task, onSuccess: { [weak self] in
            self?.loadTasks()
            completion(true)
        }, onFailure: { error in
            completion(false)
        })
    }
    

    func deleteTask(task: TaskEntity) {
        interactor.deleteTask(task: task) { [weak self] in
            self?.loadTasks()
        }
    }
}

