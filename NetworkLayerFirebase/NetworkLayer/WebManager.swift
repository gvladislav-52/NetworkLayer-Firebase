import Foundation

protocol WebManagerProtocol {
    func fetchData() async -> [UserInfo]
}

final class WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol
    
    init(requestFactory: RequestFactoryProtocol = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
    func fetchData() async -> [UserInfo] {
        guard let request = requestFactory.createRequest(for: .fetchUsers) else {
            print("Invalid Request")
            return []
        }
        
        do {
            let data = try await fetchDataFromRequest(request.toURLRequest())
            return parseResponse(data)
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    private func fetchDataFromRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
    
    private func parseResponse(_ data: Data) -> [UserInfo] {
        var userInfos: [UserInfo] = []
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let documents = jsonResponse["documents"] as? [[String: Any]] {
                for document in documents {
                    if let fields = document["fields"] as? [String: Any],
                       let name = extractValue(from: fields, forKey: "name") as? String,
                       let age = extractValue(from: fields, forKey: "age") as? String,
                       let email = extractValue(from: fields, forKey: "email") as? String {
                        let userInfo = UserInfo(name: name, age: age, email: email)
                        userInfos.append(userInfo)
                    }
                }
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
        
        return userInfos
    }
    
    private func extractValue(from fields: [String: Any], forKey key: String) -> Any? {
        if let field = fields[key] as? [String: Any], let fieldValue = field["stringValue"] as? String {
            return fieldValue
        } else if let field = fields[key] as? [String: Any], let fieldValue = field["integerValue"] as? String {
            return fieldValue
        }
        return nil
    }
}
