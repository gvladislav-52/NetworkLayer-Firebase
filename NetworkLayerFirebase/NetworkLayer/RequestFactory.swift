//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(method: HTTPMethod, bodyParams: [String: Any]?, environment: Environment) -> RequestProtocol?
}

struct RequestFactory: RequestFactoryProtocol {
    private let jsonEncoder = JSONConverterEncoder()
    
    func createRequest(method: HTTPMethod, bodyParams: [String: Any]? = nil, environment: Environment) -> RequestProtocol? {
            guard let url = environment.url() else {
                return nil
            }
            
            let body: Data? = bodyParams != nil ? jsonEncoder.convertToJSON(data: bodyParams!) : nil
            
            return Request(url: url, method: method, headers: ["Content-Type": "application/json", "Accept": "application/json"], body: body)
        }
}
