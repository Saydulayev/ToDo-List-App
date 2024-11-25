//
//  SelectedTaskView.swift
//  ToDo List App
//
//  Created by Saydulayev on 25.11.24.
//

import SwiftUI

struct SelectedTaskView: View {
    var task: TaskEntity
    
    private struct Constants {
        
        static let titleFontSize: CGFloat = 18
        static let detailsFontSize: CGFloat = 14
        static let dateFontSize: CGFloat = 12
        
        
        static let titleColor = Color.white
        static let detailsColor = Color.white
        static let dateColor = Color.white.opacity(0.5)
        static let backgroundColor = Color(.systemGray6)
        
        
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(task.title)
                .font(.system(size: Constants.titleFontSize, weight: .bold))
                .foregroundColor(Constants.titleColor)
                .lineLimit(1)
            
            if !task.details.isEmpty {
                Text(task.details)
                    .font(.system(size: Constants.detailsFontSize, weight: .regular))
                    .foregroundColor(Constants.detailsColor)
                    .lineLimit(3)
            }
            
            Text(formattedDate(task.createdAt))
                .font(.system(size: Constants.dateFontSize, weight: .regular))
                .foregroundColor(Constants.dateColor)
        }
        .padding(Constants.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Constants.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}



