//
//  AuthRepository.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct AuthRepository: Decodable {
    var idToken: String
    var refreshToken: String
    var expiresIn: String
}

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let expiresIn: String
    let tokenType: String
    let refreshToken: String
    let idToken: String
    let userId: String
    let projectId: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case userId = "user_id"
        case projectId = "project_id"
    }
}
