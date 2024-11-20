//
//  NewTaskView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

struct NewTaskView: View {
    @Binding var isPresented: Bool
    @ObservedObject var presenter: TaskPresenter
    @Binding var taskToEdit: TaskEntity?

    @State private var title: String = ""
    @State private var details: String = ""

    @State private var showErrorAlert = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Details", text: $details)
                }

                Section {
                    Button(taskToEdit == nil ? "Add Task" : "Save Changes") {
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
                                    errorMessage = "Another task with the same title already exists."
                                    showErrorAlert = true
                                }
                            }
                        } else {
                            presenter.addTask(title: title, details: details) { success in
                                if success {
                                    isPresented = false
                                } else {
                                    errorMessage = "Task with the same title already exists."
                                    showErrorAlert = true
                                }
                            }
                        }
                    }
                    .disabled(title.count < 3)
                }
            }
            .navigationTitle(taskToEdit == nil ? "New Task" : "Edit Task")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
            .onAppear {
                if let task = taskToEdit {
                    title = task.title
                    details = task.details
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "An error occurred"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

//#Preview {
//    NewTaskView()
//}
