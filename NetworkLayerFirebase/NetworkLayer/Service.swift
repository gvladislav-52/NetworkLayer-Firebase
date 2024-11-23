//
//  HomeService.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol ServiceProtocol {
    func fetchData(method: HTTPMethod) async -> [UserInfo]
    func createUser(method: HTTPMethod, model: UserInfo) async -> Bool
    func updateUser(method: HTTPMethod, model: UserInfo) async -> Bool
    func deleteUser(method: HTTPMethod, model: UserInfo) async -> Bool
}

struct Service: ServiceProtocol {
    
    func fetchData(method: HTTPMethod) async -> [UserInfo] {
        return await WebManager.shared.fetchData(method: method)
    }
    
    func createUser(method: HTTPMethod, model: UserInfo) async -> Bool {
        return await WebManager.shared.createUser(method: method, name: model.name, age: model.age, email: model.email)
    }
    
    func updateUser(method: HTTPMethod, model: UserInfo) async -> Bool {
        true
    }
    
    func deleteUser(method: HTTPMethod, model: UserInfo) async -> Bool {
        true
    }
}



