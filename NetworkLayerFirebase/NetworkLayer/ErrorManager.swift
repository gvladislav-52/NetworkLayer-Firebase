//
//  ErrorManager.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

enum ErrorManager: Error {
    case authenticationError(APIError)
    case internalError(APIError)
    case networkError(APIError)
    
    var localizedDescription: String {
        switch self {
        case .authenticationError(let type):
            return "Ошибка аутентификации: \(type.localizedDescription)"
        case .internalError(let type):
            return "Ошибка запроса: \(type.localizedDescription)"
        case .networkError(let type):
            return "Ошибка сети: \(type.localizedDescription)"
        }
    }
}
