//
//  APIResponse.swift
//  ToDo List App
//
//  Created by Saydulayev on 20.11.24.
//

import Foundation

struct APIResponse: Decodable {
    let todos: [APITask]
}



struct APITask: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
}
