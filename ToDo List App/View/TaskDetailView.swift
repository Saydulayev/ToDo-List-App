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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Text(formattedDate(task.createdAt))
                    .font(.custom("SFProText-Regular", size: 12))
                    .foregroundColor(.white).opacity(0.5)
            }
            .frame(width: 320, alignment: .leading)

            Text(task.details)
                .font(.system(size: 16, weight: .regular))
                .lineSpacing(6)
                .foregroundColor(.white)
                .frame(width: 320, alignment: .leading)
                .padding(.vertical)

            Spacer()
        }
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.yellow)
                        Text("Назад")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}


#Preview {
    TaskDetailView(task: TaskEntity(title: "New Task", details: "Do something new"))
        .preferredColorScheme(.dark)
}
