import Foundation

protocol WebManagerProtocol {
    func fetchData(method: HTTPMethod) async -> Result<[UserInfo], ErrorManager>
    func createUser(method: HTTPMethod, bodyParams: [String: Any]) async -> Result<Bool, ErrorManager>
}

struct WebManager: WebManagerProtocol {
    static let shared = WebManager()
    private let requestFactory: RequestFactoryProtocol = RequestFactory()
    private let environment = Environment()
    private let jsonDecoder = JSONConverterDecoder()
    
    func fetchData(method: HTTPMethod) async -> Result<[UserInfo], ErrorManager> {
        guard let request = requestFactory.createRequest(method: method, bodyParams: nil, environment: environment) else {
            return .failure(.internalError(.requestFailed))
        }
        
        guard let data = await performRequest(request.toURLRequest()) else {
            return .failure(.unknownError(.requestFailed))
        }
        
        if let userInfoArray = jsonDecoder.convertToUserInfoArray(data) {
            return .success(userInfoArray)
        } else {
            return .failure(.backendError(.dataParsingFailed))
        }
    }
    
    func createUser(method: HTTPMethod, bodyParams: [String: Any]) async -> Result<Bool, ErrorManager> {
        guard let request = requestFactory.createRequest(method: method, bodyParams: bodyParams, environment: environment) else {
            return .failure(.internalError(.requestFailed))
        }
        
        guard let _ = await performRequest(request.toURLRequest()) else {
            return .failure(.unknownError(.requestFailed))
        }
        
        return .success(true)
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
