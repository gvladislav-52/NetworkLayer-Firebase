import Foundation

protocol WebManagerProtocol {
    func fetchData(method: HTTPMethod) async -> [UserInfo]
    func createUser(method: HTTPMethod, name: String, age: String, email: String) async -> Bool
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let environment = Environment()
    private let jsonDecoder = JSONConverterDecoder()
    
    func fetchData(method: HTTPMethod) async -> [UserInfo] {
        guard let request = requestFactory.createRequest(method: method, bodyParams: nil, environment: environment),
              let data = await performRequest(request.toURLRequest()) else {
            return []
        }
        
        return jsonDecoder.convertToUserInfoArray(data) ?? []
    }
    
    func createUser(method: HTTPMethod, name: String, age: String, email: String) async -> Bool {
        let bodyParams: [String: Any] = [
            "fields": [
                "name": ["stringValue": name],
                "age": ["stringValue": age],
                "email": ["stringValue": email]
            ]
        ]
        
        guard let request = requestFactory.createRequest(method: method, bodyParams: bodyParams, environment: environment),
              let _ = await performRequest(request.toURLRequest()) else {
            return false
        }
        return true
    }
}

private extension WebManager {
    func performRequest(_ urlRequest: URLRequest) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return data
        } catch {
            print("Request Error: \(error.localizedDescription)")
            return nil
        }
    }
}
