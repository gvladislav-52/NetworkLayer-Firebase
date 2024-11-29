import Foundation

// MARK: - WebManagerProtocol

protocol WebManagerProtocol {
    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> T
    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool
    func getToken(email: String, password: String, url: URL, header: [String: String]) async throws
}

// MARK: - WebManager

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let authManager = AuthManager()
    private let jsonDecoder: JSONConverterDecoderProtocol = JSONConverterDecoder()
    
    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> T {
        do {
            if authManager.isTokenExpired() {
                try await refreshAccessToken(url: url, header: header)
            }
            
            guard let token = authManager.getAccessToken() else {
                throw ErrorManager.backendError(.dataParsingFailed)
            }
            
            let request = try requestFactory.createDataRequest(method: method, bodyParams: nil, url: url, header: header)
            var response = request.toURLRequest()
            response.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let data = try await performRequest(response)
            let decodedResponse: T = try jsonDecoder.decode(data)
            return decodedResponse
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            throw error
        }
    }

    func refreshAccessToken(url: URL, header: [String: String]) async throws {
        let refreshRequest = try requestFactory.createDataRequest(
            method: .post,
            bodyParams: authManager.refreshAceessToken(),
            url: url,
            header: header
        )
        
        let data = try await performRequest(refreshRequest.toURLRequest())
        let refreshResponse: AuthRepository = try jsonDecoder.decode(data)
        
        authManager.cacheToken(result: refreshResponse)
    }

    func getToken(email: String, password: String, url: URL, header: [String: String]) async throws {
        let authParameters = authManager.getAuthParameters(email: email, password: password)
        let request = try requestFactory.createDataRequest(method: .post, bodyParams: authParameters, url: url, header: header)

        let data = try await performRequest(request.toURLRequest())
        let authResponse: AuthRepository = try jsonDecoder.decode(data)
        authManager.cacheToken(result: authResponse)
    }
        
    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool {
        do {
            guard let token = authManager.getAccessToken() else {
                throw ErrorManager.backendError(.dataParsingFailed)
            }
            let request = try requestFactory.createDataRequest(method: method, bodyParams: bodyParams, url: url, header: header)
            var response = request.toURLRequest()
            response.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let _ = try await performRequest(response)
            return true
        } catch let error as ErrorManager {
            throw error
        } catch {
            throw ErrorManager.backendError(.requestFailed)
        }
    }
}

// MARK: - Private Extension

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
