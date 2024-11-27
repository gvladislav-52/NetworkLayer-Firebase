//
//  AuthManageer.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct AuthManager {
    private let accessToken: String = "accessToken"
    private let refreshToken: String = "refreshToken"
    private let expiresIn: String = "expiresIn"
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessToken)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshToken)
    }
    
    func getExpiresInToken() -> String? {
        return UserDefaults.standard.string(forKey: expiresIn)
    }
    
    func cacheToken(result: AuthRepository) {
        UserDefaults.standard.setValue(result.idToken, forKey: accessToken)
        UserDefaults.standard.setValue(result.refreshToken, forKey: refreshToken)
        UserDefaults.standard.setValue(result.expiresIn, forKey: expiresIn)
    }

    func getAuthParameters(email: String, password: String) -> [String: Any] {
        return [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
    }
}
