//
//  NewTaskView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI
import Observation

struct NewTaskView: View {
    @Binding var isPresented: Bool
    @Bindable var presenter: TaskPresenter
    @Binding var taskToEdit: TaskEntity?

    @State private var title: String = ""
    @State private var details: String = ""

    @State private var showErrorAlert = false
    @State private var errorMessage: String?

    private struct Constants {
        
        static let newTaskTitle = "Новая задача"
        static let editTaskTitle = "Редактировать задачу"
        static let cancelButtonTitle = "Отмена"
        static let errorTitle = "Ошибка"
        static let duplicateTaskMessage = "Задача с таким названием уже существует."
        static let defaultErrorMessage = "Произошла ошибка"
        static let okButtonTitle = "OK"
    }

    var body: some View {
        NavigationView {
            Form {
                TaskDetailsSection(title: $title, details: $details)
                
                SaveButtonSection(isEditing: taskToEdit != nil, title: title) {
                    handleSave()
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarItems(leading: Button(Constants.cancelButtonTitle) {
                isPresented = false
            })
            .onAppear(perform: loadTaskData)
            .alert(isPresented: $showErrorAlert, content: errorAlert)
        }
    }

    private var navigationTitle: String {
        taskToEdit == nil ? Constants.newTaskTitle : Constants.editTaskTitle
    }

    // Обработка сохранения задачи (добавление или обновление)
    private func handleSave() {
        if let task = taskToEdit {
            // Обновление существующей задачи
            let updatedTask = TaskEntity(
                id: task.id,
                title: title,
                details: details,
                createdAt: task.createdAt,
                isCompleted: task.isCompleted
            )
            presenter.updateTask(task: updatedTask) { success in
                handleSaveResult(success: success)
            }
        } else {
            // Добавление новой задачи
            presenter.addTask(title: title, details: details) { success in
                handleSaveResult(success: success)
            }
        }
    }

    private func handleSaveResult(success: Bool) {
        if success {
            isPresented = false
        } else {
            errorMessage = Constants.duplicateTaskMessage
            showErrorAlert = true
        }
    }

    // Загрузка данных задачи при редактировании
    private func loadTaskData() {
        if let task = taskToEdit {
            title = task.title
            details = task.details
        }
    }

    private func errorAlert() -> Alert {
        Alert(
            title: Text(Constants.errorTitle),
            message: Text(errorMessage ?? Constants.defaultErrorMessage),
            dismissButton: .default(Text(Constants.okButtonTitle))
        )
    }
}

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


