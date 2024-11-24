//
//  ErrorManager.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

enum ErrorManager: Error {
    case backendError(APIError)
    case internalError(APIError)
    case unknownError(APIError)
    
    var localizedDescription: String {
        switch self {
        case .backendError(let type):
            return "Backend Error: \(type.localizedDescription)"
        case .internalError(let type):
            return "Internal Error: \(type.localizedDescription)"
        case .unknownError(let type):
            return "Unknown Error: \(type.localizedDescription)"
        }
    }
}


