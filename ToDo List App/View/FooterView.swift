//
//  FooterView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

struct FooterView: View {
    @Binding var showNewTaskForm: Bool
    @Binding var editingTask: TaskEntity?
    @ObservedObject var presenter: TaskPresenter

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                // Отображение количества задач
                HStack(spacing: 4) {
                    Text(taskCountText(for: presenter.tasks.count))
                }
                .font(.custom("SF Pro", size: 11))
                .foregroundStyle(.white)
                .kerning(0.06)
                .lineSpacing(13)

                Spacer()

                // Кнопка "Добавить задачу"
                Button(action: {
                    editingTask = nil
                    showNewTaskForm.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(.yellow)
                        .frame(width: 28, height: 28)
                }
                .sheet(isPresented: $showNewTaskForm) {
                    NewTaskView(
                        isPresented: $showNewTaskForm,
                        presenter: presenter,
                        taskToEdit: $editingTask
                    )
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 49)
            .background(Color(.systemGray5))
        }
    }
    func taskCountText(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100

        if remainder100 >= 11 && remainder100 <= 19 {
            return "\(count) Задач"
        } else if remainder10 == 1 {
            return "\(count) Задача"
        } else if remainder10 >= 2 && remainder10 <= 4 {
            return "\(count) Задачи"
        } else {
            return "\(count) Задач"
        }
    }
}

