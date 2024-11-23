import Foundation

protocol WebManagerProtocol {
    func fetchData() async -> [UserInfo]
    func createUser(name: String, age: String, email: String) async -> Bool
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let environment = Environment()
    
    func fetchData() async -> [UserInfo] {
        guard let request = requestFactory.createRequest(for: .fetchUsers, environment: environment),
              let data = await performRequest(request.toURLRequest()) else {
            return []
        }
        return JSONConverter.convertToUserInfoArray(data) ?? []
    }
    
    func createUser(name: String, age: String, email: String) async -> Bool {
        guard let request = requestFactory.createRequest(for: .createUser(name: name, age: age, email: email), environment: environment),
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
