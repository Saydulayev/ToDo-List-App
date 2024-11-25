//
//  TaskInteractorProtocol.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation

protocol TaskInteractorProtocol {
    func fetchTasks(completion: @escaping ([TaskEntity]) -> Void)
    func fetchTasksFromAPI(completion: @escaping ([TaskEntity]) -> Void)
    func addTask(title: String, details: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error?) -> Void)
    func updateTask(task: TaskEntity, onSuccess: @escaping () -> Void, onFailure: @escaping (Error?) -> Void)
    func deleteTask(task: TaskEntity, completion: @escaping () -> Void)
    func searchTasks(query: String, completion: @escaping ([TaskEntity]) -> Void) // Новый метод
}
