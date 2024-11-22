import Foundation

protocol WebManagerProtocol {
    func fetchData() async -> [UserInfo]
    func createUser(name: String, age: String, email: String) async -> Bool
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private var jsonParser = JSONParser()
    private let environment = Environment()
    
    func fetchData() async -> [UserInfo] {
        return await performRequest(endpoint: .fetchUsers, parse: parseUserInfoResponse) ?? []
    }
    
    func createUser(name: String, age: String, email: String) async -> Bool {
        return await performPostRequest(endpoint: .createUser(name: name, age: age, email: email))
    }
}

private extension WebManager {
    func performRequest<T>(endpoint: APIEndpoint, parse: @escaping (Data) -> T?) async -> T? {
        guard let request = requestFactory.createRequest(for: endpoint, environment: environment) else {
            print("Invalid Request")
            return nil
        }
        
        do {
            let data = try await fetchDataFromRequest(request.toURLRequest())
            return parse(data)
        } catch {
            print("Request Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchDataFromRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
    
    func performPostRequest(endpoint: APIEndpoint) async -> Bool {
        guard let request = requestFactory.createRequest(for: endpoint, environment: environment) else {
            print("Invalid Request")
            return false
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request.toURLRequest())
            return jsonParser.parseJSON(data)
        } catch {
            print("Request Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func parseUserInfoResponse(_ data: Data) -> [UserInfo]? {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let documents = jsonResponse["documents"] as? [[String: Any]] else {
            return nil
        }
        
        return documents.compactMap { document in
            guard let fields = document["fields"] as? [String: Any] else { return nil }
            return mapUserInfo(fields: fields)
        }
    }
    
    func mapUserInfo(fields: [String: Any]) -> UserInfo? {
        guard let name = extractValue(from: fields, forKey: "name") as? String,
              let age = extractValue(from: fields, forKey: "age") as? String,
              let email = extractValue(from: fields, forKey: "email") as? String else {
            return nil
        }
        return UserInfo(name: name, age: age, email: email)
    }
    
    func extractValue(from fields: [String: Any], forKey key: String) -> Any? {
        return (fields[key] as? [String: Any])?["stringValue"] ??
               (fields[key] as? [String: Any])?["integerValue"]
    }
}
