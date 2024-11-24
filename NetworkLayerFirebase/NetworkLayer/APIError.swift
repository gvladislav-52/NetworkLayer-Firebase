//
//  APIError.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

enum APIError {
    case requestFailed
    case dataParsingFailed
    case serverError
}

extension APIError {
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Request creation or execution failed"
        case .dataParsingFailed:
            return "Data parsing failed"
        case .serverError:
            return "Server encountered an issue"
        }
    }
}

