//
//  TaskPresenterProtocol.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation

protocol TaskPresenterProtocol: ObservableObject {
    func loadTasks()
    func addTask(title: String, details: String, completion: @escaping (Bool) -> Void)
    func toggleTaskCompletion(task: TaskEntity)
    func updateTask(task: TaskEntity, completion: @escaping (Bool) -> Void)
    func deleteTask(task: TaskEntity)
}
