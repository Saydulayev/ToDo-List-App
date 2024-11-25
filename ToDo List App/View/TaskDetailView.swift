//
//  TaskDetailView.swift
//  ToDo List App
//
//  Created by Saydulayev on 23.11.24.
//

import SwiftUI

struct TaskDetailView: View {
    var task: TaskEntity

    @Environment(\.presentationMode) var presentationMode

    private struct Constants {
        
        static let titleFontSize: CGFloat = 34
        static let detailsFontSize: CGFloat = 16
        static let dateFontSize: CGFloat = 12
        static let titleFontWeight: Font.Weight = .bold
        static let detailsFontWeight: Font.Weight = .regular

        
        static let titleColor = Color.white
        static let detailsColor = Color.white
        static let dateColor = Color.gray.opacity(0.7)
        static let backButtonColor = Color.yellow

        
        static let vStackSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
        static let lineSpacing: CGFloat = 6
        static let kerning: CGFloat = 0.4
        static let hStackSpacing: CGFloat = 5

        
        static let dateFormat = "dd/MM/yy"

        
        static let backIconName = "chevron.left"

        
        static let backButtonText = "Назад"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
            Text(task.title)
                .font(.system(size: Constants.titleFontSize, weight: Constants.titleFontWeight))
                .kerning(Constants.kerning)
                .foregroundColor(Constants.titleColor)

            Text(formattedDate(task.createdAt))
                .font(.system(size: Constants.dateFontSize))
                .foregroundColor(Constants.dateColor)

            Text(task.details)
                .font(.system(size: Constants.detailsFontSize, weight: Constants.detailsFontWeight))
                .lineSpacing(Constants.lineSpacing)
                .foregroundColor(Constants.detailsColor)

            Spacer()
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: Constants.hStackSpacing) {
                        Image(systemName: Constants.backIconName)
                            .foregroundColor(Constants.backButtonColor)
                        Text(Constants.backButtonText)
                            .foregroundColor(Constants.backButtonColor)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter.string(from: date)
    }
}


#Preview {
    TaskDetailView(task: TaskEntity(title: "New Task", details: "Do something new"))
        .preferredColorScheme(.dark)
}
