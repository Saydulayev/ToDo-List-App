//
//  TaskPresenterProtocol.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation
import Observation

protocol TaskPresenterProtocol: Observable {
    var tasks: [TaskEntity] { get }
    var searchText: String { get set }
    func loadTasks()
    func searchTasks(query: String)
    func addTask(title: String, details: String, completion: @escaping (Bool) -> Void)
    func toggleTaskCompletion(task: TaskEntity)
    func updateTask(task: TaskEntity, completion: @escaping (Bool) -> Void)
    func deleteTask(task: TaskEntity)
}

