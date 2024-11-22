//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(for endpoint: APIEndpoint, environment: Environment) -> RequestProtocol?
}

struct RequestFactory: RequestFactoryProtocol {
    func createRequest(for endpoint: APIEndpoint, environment: Environment) -> RequestProtocol? {
        guard let url = environment.url(for: endpoint) else {
            return nil
        }
        switch endpoint.method {
        case .get:
            return Request(url: url, method: endpoint.method, headers: endpoint.headers, body: nil)
            
        case .post, .put, .delete:
            return Request(url: url, method: endpoint.method, headers: endpoint.headers, body: endpoint.body)
        }
    }
}
