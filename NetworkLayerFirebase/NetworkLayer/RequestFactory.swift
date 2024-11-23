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
    private let jsonEncoder = JSONConverterEncoder()
    
    func createRequest(for endpoint: APIEndpoint, environment: Environment) -> RequestProtocol? {
        guard let url = environment.url(for: endpoint) else {
            return nil
        }
        let body: Data? = createRequestBody(for: endpoint)
        return Request(url: url, method: endpoint.method, headers: endpoint.headers, body: body)
    }
    
    private func createRequestBody(for endpoint: APIEndpoint) -> Data? {
        switch endpoint {
        case .fetchUsers:
            return nil
        
        case .createUser(let name, let age, let email):
            let payload = createUserPayload(name: name, age: age, email: email)
            return jsonEncoder.convertToJSON(data: payload)
        }
    }
    
    private func createUserPayload(name: String, age: String, email: String) -> [String: Any] {
        return [
            "fields": [
                "name": ["stringValue": name],
                "age": ["stringValue": age],
                "email": ["stringValue": email]
            ]
        ]
    }
}
