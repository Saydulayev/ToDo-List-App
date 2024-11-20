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
    
    @State private var isExpanded: Bool = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                HStack {
                    Button(action: {
                        presenter.toggleTaskCompletion(task: task)
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                            .font(.system(size: 32))
                            .fontWeight(.thin)
                            .foregroundStyle(Color(hex: "#FED702"))
                    }
                    .buttonStyle(PlainButtonStyle())
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? Color(hex: "#4D555E") : Color(hex: "#F4F4F4"))
                        //#040404 цвет с галочкой
                        //##F4F4F4 цвет без галочки

                        VStack(alignment: .leading) {
                            Text(task.details)
                                .font(.subheadline)
                            Text(dateFormatter.string(from: task.createdAt))
                                .font(.footnote)
                        }

                    }
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        isExpanded.toggle()
                    }

                }

            }

            Divider()

        }
    }
}


