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
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Button(action: {
                    presenter.toggleTaskCompletion(task: task)
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(task.isCompleted ? .yellow : .secondary)
                        .fontWeight(.thin)
                        .offset(y: 9)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Текст
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(.custom("SF Pro", size: 16))
                        .fontWeight(.medium)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .secondary : .white)
                        .tracking(-0.43)
                        .lineLimit(1)
                    
                    if !task.details.isEmpty {
                        Text(task.details)
                            .font(.custom("SF Pro Text", size: 12))
                            .lineSpacing(2)
                            .foregroundColor(task.isCompleted ? .secondary : .white)
                            .lineLimit(2)
                    }
                    
                    Text(dateFormatter.string(from: task.createdAt))
                        .font(.custom("SF Pro Text", size: 12))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            Divider()
                .background(.gray)
        }
        .padding(.horizontal, 12)
        .frame(width: 360)
    }
}



