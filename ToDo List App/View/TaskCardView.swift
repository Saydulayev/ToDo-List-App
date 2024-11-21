//
//  TaskCardView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

struct TaskCardView: View {
    var task: TaskEntity
    var presenter: TaskPresenter

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy" 
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 16) {
                // Чекбокс
                Button(action: {
                    presenter.toggleTaskCompletion(task: task)
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    ZStack {
                        Circle()
                            .stroke(task.isCompleted ? Color(hex: "#FED702") : Color(hex: "#4D555E"), lineWidth: 1)
                            .frame(width: 24, height: 24)

                        if task.isCompleted {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 9)
                                .foregroundColor(Color(hex: "#FED702"))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: 6) {
                    // Заголовок задачи
                    Text(task.title)
                        .font(.custom("SF Pro", size: 16))
                        .fontWeight(.medium)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? Color(hex: "#4D555E") : Color(hex: "#F4F4F4"))
                        .lineLimit(1)

                    // Описание задачи
                    if !task.details.isEmpty {
                        Text(task.details)
                            .font(.custom("SF Pro Text", size: 12))
                            .foregroundColor(Color(hex: "#4D555E"))
                            .lineLimit(2)
                    }

                    // Дата создания задачи
                    Text(dateFormatter.string(from: task.createdAt))
                        .font(.custom("SF Pro Text", size: 12))
                        .foregroundColor(Color(hex: "#4D555E"))
                }
            }
            Divider()
                .padding(.top, 8)
        }
        .padding(.horizontal, 20)
        .frame(width: 360, height: 106)
        .cornerRadius(8)
    }
}



