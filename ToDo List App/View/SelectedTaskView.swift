//
//  SelectedTaskView.swift
//  ToDo List App
//
//  Created by Saydulayev on 25.11.24.
//

import SwiftUI

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
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}


