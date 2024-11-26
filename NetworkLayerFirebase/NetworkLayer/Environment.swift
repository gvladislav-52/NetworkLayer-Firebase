//
//  Environment.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct Environment {
    let API_KEY = "AIzaSyDIyqPzgx2RPVg6JiiWPYIjsQD-_7wEVJ8"
    let baseURL = "https://firestore.googleapis.com/v1/projects/myreportal/databases/(default)/documents"
    let authURL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="
    
    func url() -> URL {
        guard let url = URL(string: "\(baseURL)/users") else {
            fatalError("Invalid URL: \(baseURL)/users")
        }
        return url
    }
    
    func authUrl() -> URL {
        guard let url = URL(string: "\(authURL+API_KEY)") else {
            fatalError("Invalid URL: \(authURL+API_KEY)")
        }
        return url
    }
}

