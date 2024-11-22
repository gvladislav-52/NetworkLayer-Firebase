//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(for endpoint: APIEndpoint) -> RequestProtocol?
}

final class RequestFactory: RequestFactoryProtocol {
    private let environment: Environment
    
    init(environment: Environment = Environment()) {
        self.environment = environment
    }
    
    func createRequest(for endpoint: APIEndpoint) -> RequestProtocol? {
        guard let url = environment.url(for: endpoint) else { 
            return nil }
        
        return Request(
            url: url,
            method: endpoint.method,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }
}

