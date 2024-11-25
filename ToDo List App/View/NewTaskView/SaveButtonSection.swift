//
//  SaveButtonSection.swift
//  ToDo List App
//
//  Created by Saydulayev on 25.11.24.
//

import SwiftUI

struct SaveButtonSection: View {
    let isEditing: Bool
    let title: String
    let onSave: () -> Void

    private struct Constants {
        static let addButtonTitle = "Добавить задачу"
        static let saveButtonTitle = "Сохранить изменения"
        static let minTitleLength = 3
    }

    var body: some View {
        Section {
            Button(actionTitle) {
                onSave()
            }
            .disabled(title.count < Constants.minTitleLength)
        }
    }

    private var actionTitle: String {
        isEditing ? Constants.saveButtonTitle : Constants.addButtonTitle
    }
}

