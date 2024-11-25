//
//  TaskDetailsSection.swift
//  ToDo List App
//
//  Created by Saydulayev on 25.11.24.
//

import SwiftUI

struct TaskDetailsSection: View {
    @Binding var title: String
    @Binding var details: String

    private struct Constants {
        static let taskDetailsHeader = "Детали задачи"
        static let titlePlaceholder = "Название"
        static let descriptionPlaceholder = "Описание"
    }

    var body: some View {
        Section(header: Text(Constants.taskDetailsHeader)) {
            TextField(Constants.titlePlaceholder, text: $title)
            TextField(Constants.descriptionPlaceholder, text: $details)
        }
    }
}

