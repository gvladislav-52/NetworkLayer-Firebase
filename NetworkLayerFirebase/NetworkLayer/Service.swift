import Foundation

protocol ServiceProtocol {
    func fetchData(method: HTTPMethod) async throws -> [UserInfo]
    func createUser(method: HTTPMethod, model: UserInfo) async throws -> Bool
    func updateUser(method: HTTPMethod, model: UserInfo) async throws -> Bool
    func deleteUser(method: HTTPMethod, model: UserInfo) async throws -> Bool
}

struct Service: ServiceProtocol {
    
    func fetchData(method: HTTPMethod) async throws -> [UserInfo] {
        return try await WebManager.shared.fetchData(method: method)
    }
    
    func createUser(method: HTTPMethod, model: UserInfo) async throws -> Bool {
        let bodyParams: [String: Any] = [
            "fields": [
                "name": ["stringValue": model.name],
                "age": ["stringValue": model.age],
                "email": ["stringValue": model.email]
            ]
        ]
        
        return try await WebManager.shared.createUser(method: method, bodyParams: bodyParams)
    }
    
    func updateUser(method: HTTPMethod, model: UserInfo) async throws -> Bool {
        return true
    }
    
    func deleteUser(method: HTTPMethod, model: UserInfo) async throws -> Bool {
        return true
    }
}
