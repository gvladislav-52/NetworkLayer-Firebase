//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createDataRequest(method: HTTPMethod, bodyParams: [String: Any]?, url: URL, header: [String: String], token: String?) throws -> RequestProtocol
    func createAuthRequest(method: HTTPMethod, bodyParams: [String: Any]?, url: URL, header: [String: String]) throws -> RequestProtocol
}

struct RequestFactory: RequestFactoryProtocol {
    private let jsonEncoder = JSONConverterEncoder()
    
    func createDataRequest(
        method: HTTPMethod,
        bodyParams: [String: Any]? = nil,
        url: URL,
        header: [String: String],
        token: String?
    ) throws -> RequestProtocol {
        do {
            let body: Data? = try bodyParams.map { try jsonEncoder.convertToJSON(data: $0) }
            
            return DataRequest(
                url: url,
                method: method,
                headers: header,
                body: body,
                token: token
            )
        } catch {
            throw ErrorManager.internalError(.dataParsingFailed)
        }
    }
    
    func createAuthRequest(
        method: HTTPMethod,
        bodyParams: [String: Any]? = nil,
        url: URL,
        header: [String: String]
    ) throws -> RequestProtocol {
        do {
            let body: Data? = try bodyParams.map { try jsonEncoder.convertToJSON(data: $0) }
            
            return AuthRequest(
                url: url,
                method: method,
                headers: header,
                body: body,
                token: nil
            )
        } catch {
            throw ErrorManager.internalError(.dataParsingFailed)
        }
    }
}
