
import Foundation

protocol WebManagerProtocol {
    func fetchData() async -> [UserInfo]
    func createUser(name: String, age: String, email: String) async -> Bool
}

final class WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol
    
    init() { self.requestFactory = RequestFactory() }
    
    func fetchData() async -> [UserInfo] {
        return await performRequest(endpoint: .fetchUsers) { data in
            return self.parseArrayResponse(data, mapFields: { fields in
                guard let name = self.extractValue(from: fields, forKey: "name") as? String,
                      let age = self.extractValue(from: fields, forKey: "age") as? String,
                      let email = self.extractValue(from: fields, forKey: "email") as? String else {
                    return nil
                }
                return UserInfo(name: name, age: age, email: email)
            })
        } ?? []
    }
    
    func createUser(name: String, age: String, email: String) async -> Bool {
        return await requestFactory.performPostRequest(endpoint: .createUser(name: name, age: age, email: email))
    }
    
    private func performRequest<T>(endpoint: APIEndpoint, parse: (Data) -> T?) async -> T? {
        guard let request = requestFactory.createRequest(for: endpoint) else {
            print("Invalid Request")
            return nil
        }
        
        do {
            let data = try await fetchDataFromRequest(request.toURLRequest())
            return parse(data)
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func fetchDataFromRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
    
    private func parseArrayResponse<T>(_ data: Data, mapFields: ([String: Any]) -> T?) -> [T] {
        var items: [T] = []
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let documents = jsonResponse["documents"] as? [[String: Any]] {
                for document in documents {
                    if let fields = document["fields"] as? [String: Any],
                       let item = mapFields(fields) {
                        items.append(item)
                    }
                }
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
        
        return items
    }
    
    private func extractValue(from fields: [String: Any], forKey key: String) -> Any? {
        if let field = fields[key] as? [String: Any] {
            return field["stringValue"] ?? field["integerValue"]
        }
        return nil
    }
}
