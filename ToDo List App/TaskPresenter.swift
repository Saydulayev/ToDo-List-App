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
    let router: TaskRouter

    private enum Constants {
        static let userDefaultsKey = "hasLoadedTasksFromAPI"
    }

    init(interactor: TaskInteractorProtocol, router: TaskRouter) {
        self.interactor = interactor
        self.router = router
        loadTasks()
    }

    func loadTasks() {
        interactor.fetchTasks { [weak self] tasks in
            DispatchQueue.main.async {
                self?.tasks = tasks
            }
        }
    }

    func addTask(title: String, details: String, completion: @escaping (Bool) -> Void) {
        interactor.addTask(title: title, details: details, onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.loadTasks()
                completion(true)
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                completion(false)
            }
        })
    }

    func toggleTaskCompletion(task: TaskEntity) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        var updatedTask = task
        updatedTask.isCompleted.toggle()
        tasks[index] = updatedTask

        interactor.updateTask(task: updatedTask, onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.tasks[index] = updatedTask
            }
        }, onFailure: { [weak self] error in
            DispatchQueue.main.async {
                updatedTask.isCompleted.toggle()
                self?.tasks[index] = updatedTask
            }
        })
    }

    func updateTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        interactor.updateTask(task: task, onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.loadTasks()
                completion(true)
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                completion(false)
            }
        })
    }

    func deleteTask(task: TaskEntity) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks.remove(at: index)

        interactor.deleteTask(task: task) { [weak self] in
            DispatchQueue.main.async {
                self?.loadTasks()
            }
        }
    }
}
