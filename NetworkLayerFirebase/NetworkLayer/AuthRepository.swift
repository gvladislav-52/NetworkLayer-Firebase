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
