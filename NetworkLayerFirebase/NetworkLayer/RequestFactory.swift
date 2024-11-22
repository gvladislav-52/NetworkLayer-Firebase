//
//  RequestFactory.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol RequestFactoryProtocol {
    func createRequest(for endpoint: APIEndpoint) -> RequestProtocol?
    func performPostRequest(endpoint: APIEndpoint) async -> Bool
}

final class RequestFactory: RequestFactoryProtocol {
    private let environment: Environment
    private let jsonParser: JSONParser
    
    init(environment: Environment = Environment(), jsonParser: JSONParser = JSONParser()) {
        self.environment = environment
        self.jsonParser = jsonParser
    }
    
    func createRequest(for endpoint: APIEndpoint) -> RequestProtocol? {
        guard let url = environment.url(for: endpoint) else {
            return nil
        }
        
        return Request(
            url: url,
            method: endpoint.method,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }
    
    func performPostRequest(endpoint: APIEndpoint) async -> Bool {
        guard let request = createRequest(for: endpoint) else {
            print("Invalid Request")
            return false
        }
        
        do {
            let data = try await fetchDataFromRequest(request.toURLRequest())
            return jsonParser.parseJSON(data)
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    private func fetchDataFromRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
}

final class JSONParser {
    func parseJSON(_ data: Data) -> Bool {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Create response: \(jsonResponse)")
                return true
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
        return false
    }
}
