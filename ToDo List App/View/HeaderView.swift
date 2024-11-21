//
//  HeaderView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI



struct HeaderView: View {
    @Binding var showNewTaskForm: Bool
    @Binding var editingTask: TaskEntity?
    @ObservedObject var presenter: TaskPresenter

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                // Отображение количества задач
                HStack(spacing: 4) {
                    Text("\(presenter.tasks.count)")
                    Text("Задач")
                }
                .font(.custom("SF Pro", size: 11))
                .foregroundColor(Color(hex: "#F4F4F4"))
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
                        .foregroundStyle(Color(hex: "#FED702"))
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .fill(Color(hex: "#272729"))
                        )
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
            .background(Color(hex: "#272729"))
        }
    }
}

// Расширение для использования hex-кодов в SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
