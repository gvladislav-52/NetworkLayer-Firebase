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
    func getToken(email: String, password: String) async throws -> String
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let authManager = AuthManager()
    private let jsonDecoder = JSONConverterDecoder()
    
    func getToken(email: String, password: String) async throws -> String {
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(authManager.apiKey)")!
        
        let authParameters = authManager.getAuthParameters(email: email, password: password)
        let request = try requestFactory.createRequest(method: .post, bodyParams: authParameters, url: url, header: ["Content-Type": "application/json"])
        
        let data = try await performRequest(request.toURLRequest())
        let authResponse = try JSONDecoder().decode(AuthRepository.self, from: data)
        return authResponse.idToken
    }

    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> [T] {
        do {
            let request = try requestFactory.createRequest(method: method, bodyParams: nil, url: url, header: header)
            let data = try await performRequest(request.toURLRequest())
            return try jsonDecoder.convertToModelArray(data)
            
        } catch let error as ErrorManager {
            throw error
        } catch {
            throw ErrorManager.backendError(.dataParsingFailed)
        }
    }

    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool {
        do {
            let request = try requestFactory.createRequest(method: method, bodyParams: bodyParams, url: url, header: header)
            let _ = try await performRequest(request.toURLRequest())
            return true
            
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
