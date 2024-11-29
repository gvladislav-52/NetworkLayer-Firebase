//
//  APIError.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

enum APIError {
    case unauthorized
    case requestCreationFailed
    case dataSerializationFailed
    case dataParsingFailed
    case httpFailed(Int)
    case requestFailed
    case invalidURL
    case networkUnavailable
    case requestTimeout
    case sslHandshakeFailed
    case serverUnreachable
    case unknownError
}

extension APIError {
    var localizedDescription: String {
        switch self {
        case .unknownError:
            return "Неизвестная ошибка"
        case .unauthorized:
            return "Ошибка авторизации"
        case .requestCreationFailed:
            return "Ошибка составления запроса"
        case .dataSerializationFailed:
            return "Ошибка сериализации данных"
        case .dataParsingFailed:
            return "Ошибка парсинга данных"
        case .httpFailed(let statusCode):
            return "HTTP запрос завершился с кодом ошибки: \(statusCode)"
        case .requestFailed:
            return "Не удалось выполнить запрос"
        case .invalidURL:
            return "Некорректный URL"
        case .networkUnavailable:
            return "Нет доступного подключения к сети"
        case .requestTimeout:
            return "Превышено время ожидания запроса"
        case .sslHandshakeFailed:
            return "Ошибка при установлении защищенного соединения"
        case .serverUnreachable:
            return "Сервер не доступен"
        }
    }
}
