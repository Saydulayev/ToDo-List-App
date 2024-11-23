//
//  ContentView.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var presenter: TaskPresenter
    @State private var showNewTaskForm: Bool = false
    @State private var editingTask: TaskEntity? = nil

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TaskListView(
                    presenter: presenter,
                    showNewTaskForm: $showNewTaskForm,
                    editingTask: $editingTask
                )

                FooterView(
                    showNewTaskForm: $showNewTaskForm,
                    editingTask: $editingTask,
                    presenter: presenter
                )
            }
        }
    }
}




#Preview {
    let interactor = TaskInteractor()
    let presenter = TaskPresenter(interactor: interactor, router: TaskRouter())
    ContentView(presenter: presenter)
        .preferredColorScheme(.dark)
}
