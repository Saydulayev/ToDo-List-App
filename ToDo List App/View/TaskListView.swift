//
//  TaskListView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

struct TaskListView: View {
    var presenter: TaskPresenter
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
                                    .frame(width: 350)
                                    .background(Color(#colorLiteral(red: 0.153, green: 0.153, blue: 0.158, alpha: 1)))
                                    .cornerRadius(12)
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .background(Color.clear)
            .alert(isPresented: $showAlert) {
                taskDeleteAlert
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



struct SelectedTaskView: View {
    var task: TaskEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Заголовок задачи
            Text(task.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            // Детали задачи
            if !task.details.isEmpty {
                Text(task.details)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white)
                    .lineLimit(3)
            }
            
            // Дата создания
            Text(formattedDate(task.createdAt))
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)  
        .background(Color(#colorLiteral(red: 0.1531544924, green: 0.1531046033, blue: 0.1584302485, alpha: 1)))
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
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
