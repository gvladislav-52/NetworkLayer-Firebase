//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(method: HTTPMethod, bodyParams: [String: Any]?, url: URL, header: [String: String]) -> RequestProtocol?
}

struct RequestFactory: RequestFactoryProtocol {
    private let jsonEncoder = JSONConverterEncoder()
    
    func createRequest(method: HTTPMethod, bodyParams: [String: Any]? = nil, url: URL, header: [String: String]) -> RequestProtocol? {
            let body: Data? = bodyParams != nil ? jsonEncoder.convertToJSON(data: bodyParams!) : nil
            
            return Request(
                url: url,
                method: method,
                headers: header,
                body: body
            )
        }
}
