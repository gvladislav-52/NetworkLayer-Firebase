import Foundation

import Foundation

protocol WebManagerProtocol {
    func fetchData(completion: @escaping ([UserInfo]) -> Void)
}

final class WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol
    
    init(requestFactory: RequestFactoryProtocol = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
    func fetchData(completion: @escaping ([UserInfo]) -> Void) {
        guard let request = requestFactory.createRequest(for: .fetchUsers) else {
            print("Invalid URLRequest")
            completion([])
            return
        }
        
        fetchDataFromRequest(request) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            let parsedData = self.parseResponse(data)
            completion(parsedData)
        }
    }
}

private extension WebManager {
    func fetchDataFromRequest(_ request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
    
    func parseResponse(_ data: Data) -> [UserInfo] {
        var userInfos: [UserInfo] = []
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let documents = jsonResponse["documents"] as? [[String: Any]] {
                for document in documents {
                    if let fields = document["fields"] as? [String: Any] {
                        if let name = extractValue(from: fields, forKey: "name") as? String,
                           let age = extractValue(from: fields, forKey: "age") as? String,
                           let email = extractValue(from: fields, forKey: "email") as? String {
                            let userInfo = UserInfo(name: name, age: age, email: email)
                            userInfos.append(userInfo)
                        }
                    }
                }
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
        
        return userInfos
    }
    
    func extractValue(from fields: [String: Any], forKey key: String) -> Any? {
        if let field = fields[key] as? [String: Any], let fieldValue = field["stringValue"] as? String {
            return fieldValue
        } else if let field = fields[key] as? [String: Any], let fieldValue = field["integerValue"] as? String {
            return fieldValue
        }
        return nil
    }
}
