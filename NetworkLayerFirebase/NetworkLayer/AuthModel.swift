//
//  AuthModel.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 29.11.2024.
//

import Foundation

protocol ResponseProtocol {
    var idToken: String { get }
    var refreshToken: String { get }
    var expiresIn: String { get }
}
struct AuthResponse: Decodable, ResponseProtocol {
    var idToken: String
    var refreshToken: String
    var expiresIn: String
}

struct RefreshAuthResponse: Decodable, ResponseProtocol{
    var idToken: String
    var refreshToken: String
    var expiresIn: String
    
    enum CodingKeys: String, CodingKey {
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
    }
}
