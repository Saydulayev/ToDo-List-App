//
//  FooterView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI
import Observation

struct FooterView: View {
    @Binding var showNewTaskForm: Bool
    @Binding var editingTask: TaskEntity?
    @Bindable var presenter: TaskPresenter

    private struct Constants {

        static let horizontalPadding: CGFloat = 16
        static let footerHeight: CGFloat = 49
        static let buttonSize: CGFloat = 28
        static let buttonFontSize: CGFloat = 22
        static let taskCountFontSize: CGFloat = 11
        static let taskCountKerning: CGFloat = 0.06
        static let taskCountLineSpacing: CGFloat = 13
        static let taskCountSpacing: CGFloat = 4
        
        
        static let backgroundColor = Color(red: 0.153, green: 0.153, blue: 0.158)
        static let taskCountTextColor = Color.white
        static let addButtonColor = Color.yellow
        
        
        static let taskCountFontName = "SF Pro"
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()


                HStack(spacing: Constants.taskCountSpacing) {
                    Text(taskCountText(for: presenter.tasks.count))
                }
                .font(.custom(Constants.taskCountFontName, size: Constants.taskCountFontSize))
                .foregroundStyle(Constants.taskCountTextColor)
                .kerning(Constants.taskCountKerning)
                .lineSpacing(Constants.taskCountLineSpacing)

                Spacer()

                Button(action: {
                    editingTask = nil
                    showNewTaskForm.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: Constants.buttonFontSize, weight: .regular))
                        .foregroundStyle(Constants.addButtonColor)
                        .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                }
                .sheet(isPresented: $showNewTaskForm) {
                    NewTaskView(
                        isPresented: $showNewTaskForm,
                        presenter: presenter,
                        taskToEdit: $editingTask
                    )
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .frame(height: Constants.footerHeight)
            .background(Constants.backgroundColor)
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

