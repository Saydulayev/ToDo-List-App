//
//  TaskModuleBuilder.swift
//  ToDo List App
//
//  Created by Saydulayev on 25.11.24.
//

import SwiftUI

struct TaskModuleBuilder {
    static func createModule() -> some View {
        let interactor = TaskInteractor()
        let router = TaskRouter()
        let presenter = TaskPresenter(interactor: interactor, router: router)
        
        return ContentView(presenter: presenter)
    }
}
