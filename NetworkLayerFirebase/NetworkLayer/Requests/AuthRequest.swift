//
//  AuthRequest.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 27.11.2024.
//

import Foundation

protocol AuthRequestProtocol {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    
    func toURLRequest() -> URLRequest
}

struct AuthRequest: AuthRequestProtocol {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    
    func toURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}
