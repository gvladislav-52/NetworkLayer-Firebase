import Foundation

protocol WebManagerProtocol {
    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> [T]
    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let jsonDecoder = JSONConverterDecoder()
    
    
    func fetchData<T: Decodable>(method: HTTPMethod, url: URL, header: [String: String]) async throws -> [T] {
        guard let request = requestFactory.createRequest(method: method, bodyParams: nil, url: url, header: header) else {
            throw ErrorManager.internalError(.requestFailed)
        }
        
        guard let data = await performRequest(request.toURLRequest()) else {
            throw ErrorManager.unknownError(.requestFailed)
        }
        do {
            return try jsonDecoder.convertToModelArray(data)
        } catch {
            throw ErrorManager.backendError(.dataParsingFailed)
        }
    }

    
    func createUser(method: HTTPMethod, bodyParams: [String: Any], url: URL, header: [String: String]) async throws -> Bool {
        guard let request = requestFactory.createRequest(method: method, bodyParams: bodyParams, url: url, header: header) else {
            throw ErrorManager.internalError(.requestFailed)
        }
        
        guard let _ = await performRequest(request.toURLRequest()) else {
            throw ErrorManager.unknownError(.requestFailed)
        }
        
        return true
    }
}

private extension WebManager {
    func performRequest(_ urlRequest: URLRequest) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return data
        } catch {
            print("Request Error: \(error.localizedDescription)")
            return nil
        }
    }
}
