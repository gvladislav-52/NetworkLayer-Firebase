//
//  WebManager.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

protocol WebManagerProtocol {
    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> [T]
    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool
    func getToken(email: String, password: String, url: URL, header: [String: String]) async throws
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let authManager = AuthManager()
    private let jsonDecoder = JSONConverterDecoder()
    
    func getToken(email: String, password: String, url: URL, header: [String: String]) async throws {
        let authParameters = authManager.getAuthParameters(email: email, password: password)
        let request = try requestFactory.createAuthRequest(method: .post, bodyParams: authParameters, url: url, header: header)
        if let urlRequest = request.toURLRequest() {
            let data = try await performRequest(urlRequest)
            let authResponse = try JSONDecoder().decode(AuthRepository.self, from: data)
            authManager.token = authResponse.idToken
        } else {
            throw ErrorManager.backendError(.requestFailed)
        }
    }

    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> [T] {
        do {
            let request = try requestFactory.createDataRequest(method: method, bodyParams: nil, url: url, header: header, token:  authManager.token)
            if let urlRequest = request.toURLRequest() {
                let data = try await performRequest(urlRequest)
                return try jsonDecoder.convertToModelArray(data)
            } else {
                throw ErrorManager.backendError(.requestFailed)
            }
            
        } catch let error as ErrorManager {
            throw error
        } catch {
            throw ErrorManager.backendError(.dataParsingFailed)
        }
    }

    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool {
        do {
            let request = try requestFactory.createDataRequest(method: method, bodyParams: bodyParams, url: url, header: header, token:  authManager.token)
            if let urlRequest = request.toURLRequest() {
                let _ = try await performRequest(urlRequest)
                return true
            } else {
                throw ErrorManager.backendError(.requestFailed)
            }
            
        } catch let error as ErrorManager {
            throw error
        } catch {
            throw ErrorManager.backendError(.requestFailed)
        }
    }
}

private extension WebManager {
    func performRequest(_ urlRequest: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw ErrorManager.backendError(.serverError)
            }
            return data
        } catch {
            throw ErrorManager.unknownError(.requestFailed)
        }
    }
}
