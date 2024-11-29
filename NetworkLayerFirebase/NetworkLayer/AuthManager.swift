//
//  AuthManageer.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct AuthManager {
    private let repository = AuthRepository()
    
    var accessToken: String? {
        repository.getAccessToken()
    }
    
    var refreshToken: String? {
        repository.getRefreshToken()
    }
    
    var expirationDate: Date? {
        repository.getExpirationDate()
    }
    
    func isTokenExpired() -> Bool {
        guard let expirationDate = expirationDate else {
            return true
        }
        return Date() >= expirationDate
    }
    
    func refreshTokenRequestBody() -> [String: Any]? {
        guard let refreshToken = refreshToken else {
            return nil
        }
        return [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
    }
    
    func accessTokenRequestBody(email: String, password: String) -> [String: Any] {
        return [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
    }
    
    func cacheToken(from response: ResponseProtocol) {
        repository.saveToken(
            accessToken: response.idToken,
            refreshToken: response.refreshToken,
            expiresIn: response.expiresIn
        )
    }
}
