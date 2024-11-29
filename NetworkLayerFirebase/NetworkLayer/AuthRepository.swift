//
//  AuthRepository.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct AuthRepository {
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let expiresInKey = "expiresIn"
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    func getExpirationDate() -> Date? {
        guard let expiresInString = UserDefaults.standard.string(forKey: expiresInKey) else {
            return nil
        }
        return ISO8601DateFormatter().date(from: expiresInString)
    }
    
    func saveToken(accessToken: String, refreshToken: String, expiresIn: String) {
        UserDefaults.standard.setValue(accessToken, forKey: accessTokenKey)
        UserDefaults.standard.setValue(refreshToken, forKey: refreshTokenKey)
        
        if let expiresInSeconds = Double(expiresIn) {
            let expirationDate = Date().addingTimeInterval(expiresInSeconds)
            let isoFormatter = ISO8601DateFormatter()
            UserDefaults.standard.setValue(isoFormatter.string(from: expirationDate), forKey: expiresInKey)
        }
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: expiresInKey)
    }
}
