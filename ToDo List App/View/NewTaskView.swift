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
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Детали задачи")) { 
                    TextField("Название", text: $title)
                    TextField("Описание", text: $details)
                }
                
                Section {
                    Button(taskToEdit == nil ? "Добавить задачу" : "Сохранить изменения") {
                        if let task = taskToEdit {
                            presenter.updateTask(task: TaskEntity(
                                id: task.id,
                                title: title,
                                details: details,
                                createdAt: task.createdAt,
                                isCompleted: task.isCompleted)
                            ) { success in
                                if success {
                                    isPresented = false
                                } else {
                                    errorMessage = "Задача с таким названием уже существует." 
                                    showErrorAlert = true
                                }
                            }
                        } else {
                            presenter.addTask(title: title, details: details) { success in
                                if success {
                                    isPresented = false
                                } else {
                                    errorMessage = "Задача с таким названием уже существует."
                                    showErrorAlert = true
                                }
                            }
                        }
                    }
                    .disabled(title.count < 3)
                }
            }
            .navigationTitle(taskToEdit == nil ? "Новая задача" : "Редактировать задачу")
            .navigationBarItems(leading: Button("Отмена") {
                isPresented = false
            })
            .onAppear {
                if let task = taskToEdit {
                    title = task.title
                    details = task.details
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(errorMessage ?? "Произошла ошибка"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}


