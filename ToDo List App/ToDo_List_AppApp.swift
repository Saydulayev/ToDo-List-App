//
//  ToDo_List_AppApp.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import SwiftUI

@main
struct ToDo_List_AppApp: App {
    var body: some Scene {
        WindowGroup {
            TaskModuleBuilder.createModule()
                .preferredColorScheme(.light)
        }
    }
}
