//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(for endpoint: APIEndpoint) -> URLRequest?
}

final class RequestFactory: RequestFactoryProtocol {
    private let environment: Environment
    
    init(environment: Environment = Environment()) {
        self.environment = environment
    }
    
    func createRequest(for endpoint: APIEndpoint) -> URLRequest? {
        guard let url = environment.url(for: endpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        return request
    }
}
