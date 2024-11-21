import Foundation

protocol WebManagerProtocol {
    func fetchData(collection: String, completion: @escaping ([[String: Any]]) -> Void)
}

final class WebManager: WebManagerProtocol {
    
    static let shared = WebManager()
    private let projectId = "myreportal"
    
    func fetchData(collection: String, completion: @escaping ([[String: Any]]) -> Void) {
        guard let url = templateEnvironment(collection) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        fetchDataFromURL(from: url) { data, error in
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
    func templateEnvironment(_ collection: String) -> URL? {
        return URL(string: "https://firestore.googleapis.com/v1/projects/\(projectId)/databases/(default)/documents/\(collection)")
    }
    
    func fetchDataFromURL(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, error)
        }
        task.resume()
    }
    
    func parseResponse(_ data: Data) -> [[String: Any]] {
        var allUserInfo: [[String: Any]] = []
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let documents = jsonResponse["documents"] as? [[String: Any]] {
                for document in documents {
                    if let fields = document["fields"] as? [String: Any] {
                        var userInfo: [String: Any] = [:]
                        
                        userInfo["name"] = extractValue(from: fields, forKey: "name")
                        userInfo["age"] = extractValue(from: fields, forKey: "age")
                        userInfo["email"] = extractValue(from: fields, forKey: "email")
                        
                        if !userInfo.isEmpty {
                            allUserInfo.append(userInfo)
                        }
                    }
                }
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
        
        return allUserInfo
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
