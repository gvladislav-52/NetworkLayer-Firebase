//
//  Environment.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct Environment {
    private let API_KEY: String = "" ///"AIzaSyDIyqPzgx2RPVg6JiiWPYIjsQD-_7wEVJ8"
    private let databaseURL = "https://firestore.googleapis.com/v1/projects/myreportal/databases/(default)/documents/"
    private let authURL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="
    private let refreshAuthURL = "https://securetoken.googleapis.com/v1/token?key="
    func getDatabaseURL(endPoint: EnvironmentEndPoint) -> URL {
        guard let url = URL(string: "\(databaseURL+endPoint.rawValue)") else {
            fatalError("Invalid URL: \(databaseURL+endPoint.rawValue)")
        }
        return url
    }
    
    func getAuthURL() -> URL {
        guard let url = URL(string: "\(authURL+API_KEY)") else {
            fatalError("Invalid URL: \(authURL+API_KEY)")
        }
        return url
    }
    
    func getRefreshAuthURL() -> URL {
        guard let url = URL(string: "\(refreshAuthURL+API_KEY)") else {
            fatalError("Invalid URL: \(refreshAuthURL+API_KEY)")
        }
        return url
    }
}

enum EnvironmentEndPoint: String {
    case home = "users2/"
}

