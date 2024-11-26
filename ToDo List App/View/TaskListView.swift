//
//  TaskListView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI
import Observation

struct TaskListView: View {
    @Bindable var presenter: TaskPresenter
    @Binding var showNewTaskForm: Bool
    @Binding var editingTask: TaskEntity?
    
    @State private var showAlert = false
    @State private var taskToDelete: TaskEntity?
    
    private struct Constants {
        
        static let navigationTitle = "Задачи"
        static let deleteTaskTitle = "Удалить задачу"
        static let deleteTaskMessage = "Вы уверены, что хотите удалить эту задачу?"
        static let deleteButtonTitle = "Да"
        static let cancelButtonTitle = "Отменить"
        
        
        static let listRowWidth: CGFloat = 350
        static let listRowCornerRadius: CGFloat = 12
        
        
        static let backgroundColor = Color(red: 0.153, green: 0.153, blue: 0.158)
        static let clearColor = Color.clear
    }
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $presenter.searchText)
            
            List {
                ForEach(filteredTasks, id: \.id) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskCardView(task: task, presenter: presenter)
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
                            } preview: {
                                SelectedTaskView(task: task)
                                    .frame(width: Constants.listRowWidth)
                                    .background(Constants.backgroundColor)
                                    .cornerRadius(Constants.listRowCornerRadius)
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Constants.clearColor)
                }
            }
            .alert(isPresented: $showAlert) {
                taskDeleteAlert
            }
        }
        .navigationTitle(Constants.navigationTitle)
    }
    
    private var filteredTasks: [TaskEntity] {
        if presenter.searchText.isEmpty {
            return presenter.tasks
        } else {
            return presenter.tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(presenter.searchText) ||
                task.details.localizedCaseInsensitiveContains(presenter.searchText)
            }
        }
    }
    
    private var taskDeleteAlert: Alert {
        Alert(
            title: Text(Constants.deleteTaskTitle),
            message: Text(Constants.deleteTaskMessage),
            primaryButton: .destructive(Text(Constants.deleteButtonTitle)) {
                if let taskToDelete = taskToDelete {
                    presenter.deleteTask(task: taskToDelete)
                }
            },
            secondaryButton: .cancel(Text(Constants.cancelButtonTitle))
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
