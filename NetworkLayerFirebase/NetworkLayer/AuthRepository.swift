//
//  AuthRepository.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct AuthRepository: Decodable {
    let idToken: String
    let email: String
    let refreshToken: String
    let expiresIn: String
    let localId: String
}
