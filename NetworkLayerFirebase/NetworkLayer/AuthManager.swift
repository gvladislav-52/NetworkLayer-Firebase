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
        
        if let expiresInSeconds = Double(result.expiresIn) {
            let expirationDate = Date().addingTimeInterval(expiresInSeconds)
            let isoFormatter = ISO8601DateFormatter()
            UserDefaults.standard.setValue(isoFormatter.string(from: expirationDate), forKey: expiresIn)
        }
    }
    
    func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.idToken, forKey: accessToken)
        UserDefaults.standard.setValue(result.refreshToken, forKey: refreshToken)
        
        if let expiresInSeconds = Double(result.expiresIn) {
            let expirationDate = Date().addingTimeInterval(expiresInSeconds)
            let isoFormatter = ISO8601DateFormatter()
            UserDefaults.standard.setValue(isoFormatter.string(from: expirationDate), forKey: expiresIn)
        }
    }
    
    func isTokenExpired() -> Bool {
        guard let expiresIn = getExpiresInToken(),
              let expirationDate = ISO8601DateFormatter().date(from: expiresIn) else {
            return true
        }
        return Date() >= expirationDate
    }
    
    func refreshAceessToken() -> [String: Any]? {
        guard let refreshToken = getRefreshToken() else {
                return nil
            }
        return [
            "grant_type": "refresh_token",
            "refresh_token": getRefreshToken()!
        ]
    }

    func getAuthParameters(email: String, password: String) -> [String: Any] {
        return [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
    }
}
