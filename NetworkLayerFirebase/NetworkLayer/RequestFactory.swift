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
        
        var body: Data?
        
        switch endpoint {
        case .fetchUsers:
            body = nil
            
        case .createUser(let name, let age, let email):
            let payload: [String: Any] = [
                "fields": [
                    "name": ["stringValue": name],
                    "age": ["stringValue": "\(age)"],
                    "email": ["stringValue": "\(email)"]
                ]
            ]
            body = JSONConverter.convertToJSON(data: payload)
        }
        
        return Request(url: url, method: endpoint.method, headers: endpoint.headers, body: body)
    }
}
