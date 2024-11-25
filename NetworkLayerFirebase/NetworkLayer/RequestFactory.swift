//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(method: HTTPMethod, bodyParams: [String: Any]?, url: URL, header: [String: String]) throws -> RequestProtocol
}

struct RequestFactory: RequestFactoryProtocol {
    private let jsonEncoder = JSONConverterEncoder()
    
    func createRequest(
        method: HTTPMethod,
        bodyParams: [String: Any]? = nil,
        url: URL,
        header: [String: String]
    ) throws -> RequestProtocol {
        do {
            let body: Data? = try bodyParams.map { try jsonEncoder.convertToJSON(data: $0) }
            
            return Request(
                url: url,
                method: method,
                headers: header,
                body: body
            )
        } catch {
            throw ErrorManager.internalError(.dataParsingFailed)
        }
    }
}
