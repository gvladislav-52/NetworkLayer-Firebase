//
//  Environment.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct Environment {
    let baseURL = "https://firestore.googleapis.com/v1/projects/myreportal/databases/(default)/documents"
    
    func url() -> URL {
        guard let url = URL(string: "\(baseURL)/users") else {
            fatalError("Invalid URL: \(baseURL)/users")
        }
        return url
    }
}

