//
//  TaskListView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

struct TaskListView: View {
    @State var presenter: TaskPresenter
    @Binding var showNewTaskForm: Bool
    @Binding var editingTask: TaskEntity?
    
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var taskToDelete: TaskEntity?
    
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $searchText)
            
            List {
                ForEach(filteredTasks, id: \.id) { task in
                    NavigationLink(value: task) {
                        TaskCardView(task: task, presenter: presenter)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .contextMenu {
                        TaskContextMenu(
                            task: task,
                            onEdit: {
                                editingTask = task
                                showNewTaskForm.toggle()
                            },
                            onDelete: {
                                taskToDelete = task
                                showAlert.toggle()
                            } 
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .alert(isPresented: $showAlert) {
                taskDeleteAlert
            }
            .navigationDestination(for: TaskEntity.self) { task in
                TaskDetailView(task: task)
            }
        }
        .navigationTitle("Задачи")
    }
    
    private var filteredTasks: [TaskEntity] {
        if searchText.isEmpty {
            return presenter.tasks
        } else {
            return presenter.tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.details.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var taskDeleteAlert: Alert {
        Alert(
            title: Text("Удалить задачу"),
            message: Text("Вы уверены, что хотите удалить эту задачу?"),
            primaryButton: .destructive(Text("Да")) {
                if let taskToDelete = taskToDelete {
                    presenter.deleteTask(task: taskToDelete)
                }
            },
            secondaryButton: .cancel(Text("Отменить"))
        )
    }
}




private struct TaskContextMenu: View {
    var task: TaskEntity
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        Group {
            Button(action: onEdit) {
                Label("Редактировать", systemImage: "pencil")
            }
            Button(action: {
                shareTask(task)
            }) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            Button(role: .destructive, action: onDelete) {
                Label("Удалить", systemImage: "trash")
            }
        }
    }

    private func shareTask(_ task: TaskEntity) {
        let taskDetails = """
        Задача: \(task.title)
        Описание: \(task.details)
        Дата создания: \(formattedDate(task.createdAt))
        Статус: \(task.isCompleted ? "Выполнено" : "Не выполнено")
        """

        let activityVC = UIActivityViewController(activityItems: [taskDetails], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

