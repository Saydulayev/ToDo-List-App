//
//  TaskEntity.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation

struct TaskEntity: Identifiable {
    let id: UUID
    var title: String
    var details: String
    let createdAt: Date
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, details: String, createdAt: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}
