//
//  AuthManageer.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

class AuthManager {
    var token: String?
    func getAuthParameters(email: String, password: String) -> [String: Any] {
        return [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
    }
}

