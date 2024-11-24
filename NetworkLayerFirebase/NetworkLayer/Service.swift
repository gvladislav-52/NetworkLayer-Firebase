import Foundation

protocol ServiceProtocol {
    func fetchData(method: HTTPMethod) async -> Result<[UserInfo], ErrorManager>
    func createUser(method: HTTPMethod, model: UserInfo) async -> Result<Bool, ErrorManager>
    func updateUser(method: HTTPMethod, model: UserInfo) async -> Result<Bool, ErrorManager>
    func deleteUser(method: HTTPMethod, model: UserInfo) async -> Result<Bool, ErrorManager>
}

struct Service: ServiceProtocol {
    
    func fetchData(method: HTTPMethod) async -> Result<[UserInfo], ErrorManager> {
        return await WebManager.shared.fetchData(method: method)
    }
    
    func createUser(method: HTTPMethod, model: UserInfo) async -> Result<Bool, ErrorManager> {
        let bodyParams: [String: Any] = [
            "fields": [
                "name": ["stringValue": model.name],
                "age": ["stringValue": model.age],
                "email": ["stringValue": model.email]
            ]
        ]
        
        return await WebManager.shared.createUser(method: method, bodyParams: bodyParams)
    }
    
    func updateUser(method: HTTPMethod, model: UserInfo) async -> Result<Bool, ErrorManager> {
        return .success(true)
    }
    
    func deleteUser(method: HTTPMethod, model: UserInfo) async -> Result<Bool, ErrorManager> {
        return .success(true)
    }
}
