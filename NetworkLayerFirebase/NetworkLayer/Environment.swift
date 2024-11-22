//
//  Environment.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct Environment {
    internal let baseURL = "https://firestore.googleapis.com/v1/projects/myreportal/databases/(default)/documents"
    
    func url(for endpoint: APIEndpoint) -> URL? {
        switch endpoint {
        case .fetchUsers:
            return URL(string: "\(baseURL)/users")
        case .createUser:
            return URL(string: "\(baseURL)/users")
        }
    }
}

enum APIEndpoint {
    case fetchUsers
    case createUser(name: String, age: String, email: String)
    
    var method: HTTPMethod {
        switch self {
        case .fetchUsers: return .get
        case .createUser: return .post
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    var body: Data? {
        switch self {
        case .fetchUsers:
            return nil
        case .createUser(let name, let age, let email):
            let payload: [String: Any] = [
                "fields": [
                    "name": ["stringValue": name],
                    "age": ["stringValue": "\(age)"],
                    "email": ["stringValue": "\(email)"]
                ]
            ]
            return try? JSONSerialization.data(withJSONObject: payload)
        }
    }

}
