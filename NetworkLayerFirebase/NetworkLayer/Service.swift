//
//  Service.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

protocol ServiceProtocol {
    func fetchData(method: HTTPMethod) async throws -> TestModel
    func createUser(method: HTTPMethod, model: TestModel) async throws -> Bool
    func updateUser(method: HTTPMethod, model: TestModel) async throws -> Bool
    func deleteUser(method: HTTPMethod, model: TestModel) async throws -> Bool
    
    func getAuthToken(email: String, password: String) async throws
}

struct Service: ServiceProtocol {    
    func fetchData(method: HTTPMethod) async throws -> TestModel {
        do {
            return try await WebManager.shared.fetchData(
                method: method,
                endPoint: .home,
                header: ["Content-Type": "application/json", "Accept": "application/json"]
            )
        } catch  {
            throw error
        }
    }

    func createUser(method: HTTPMethod, model: TestModel) async throws -> Bool {
        let bodyParams: [String: Any] = [
            "fields": [
                "name": ["stringValue": "model.name"],
                "age": ["stringValue": "model.age"],
                "email": ["stringValue": "model.email"]
            ]
        ]
        
        do {
            return try await WebManager.shared.createUser(
                method: method,
                bodyParams: bodyParams,
                endPoint: .home,
                header: ["Content-Type": "application/json", "Accept": "application/json"]
            )
        } catch  {
            throw error
        }
    }
    
    func updateUser(method: HTTPMethod, model: TestModel) async throws -> Bool {
        true
    }
    
    func deleteUser(method: HTTPMethod, model: TestModel) async throws -> Bool {
        true
    }
    
    func getAuthToken(email: String, password: String) async throws {
        do {
        return try await WebManager.shared.getToken(
            email: email,
            password: password,
            header: ["Content-Type": "application/json"]
        )
        } catch  {
            throw error
        }
    }
}
