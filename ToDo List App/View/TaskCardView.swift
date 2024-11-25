//
//  TaskCardView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI
import Observation

struct TaskCardView: View {
    var task: TaskEntity
    @Bindable var presenter: TaskPresenter

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }()

    private struct Constants {
        
        static let titleFontName = "SF Pro"
        static let detailsFontName = "SF Pro Text"
        static let titleFontSize: CGFloat = 16
        static let detailsFontSize: CGFloat = 12

        
        static let completedColor = Color.secondary
        static let activeColor = Color.white
        static let iconCompletedColor = Color.yellow
        static let iconActiveColor = Color.secondary
        static let dividerColor = Color.gray

        
        static let vStackSpacing: CGFloat = 12
        static let hStackSpacing: CGFloat = 12
        static let innerVStackSpacing: CGFloat = 6
        static let paddingHorizontal: CGFloat = 12
        static let frameWidth: CGFloat = 360
        static let iconSize: CGFloat = 24
        static let iconOffsetY: CGFloat = 9

        
        static let dateFormat = "dd/MM/yy"
        static let tracking: CGFloat = -0.43
        static let lineSpacing: CGFloat = 2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
            HStack(alignment: .firstTextBaseline, spacing: Constants.hStackSpacing) {
                Button(action: {
                    presenter.toggleTaskCompletion(task: task)
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: Constants.iconSize, height: Constants.iconSize)
                        .foregroundColor(task.isCompleted ? Constants.iconCompletedColor : Constants.iconActiveColor)
                        .fontWeight(.thin)
                        .offset(y: Constants.iconOffsetY)
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: Constants.innerVStackSpacing) {
                    Text(task.title)
                        .font(.custom(Constants.titleFontName, size: Constants.titleFontSize))
                        .fontWeight(.medium)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? Constants.completedColor : Constants.activeColor)
                        .tracking(Constants.tracking)
                        .lineLimit(1)

                    if !task.details.isEmpty {
                        Text(task.details)
                            .font(.custom(Constants.detailsFontName, size: Constants.detailsFontSize))
                            .lineSpacing(Constants.lineSpacing)
                            .foregroundColor(task.isCompleted ? Constants.completedColor : Constants.activeColor)
                            .lineLimit(2)
                    }

                    Text(dateFormatter.string(from: task.createdAt))
                        .font(.custom(Constants.detailsFontName, size: Constants.detailsFontSize))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)

            Divider()
                .background(Constants.dividerColor)
        }
        .padding(.horizontal, Constants.paddingHorizontal)
        .frame(width: Constants.frameWidth)
    }
}




