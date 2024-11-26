//
//  Request.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestProtocol {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var token: String? { get }
    
    func toURLRequest() -> URLRequest?
}

struct DataRequest: RequestProtocol {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let token: String?
    
    func toURLRequest() -> URLRequest? {
        guard let token = token else {
            print("Ошибка: отсутствует токен")
            return nil
        }
            
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = body
        
        return urlRequest
    }
}

struct AuthRequest: RequestProtocol {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let token: String?
    
    func toURLRequest() -> URLRequest? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}

