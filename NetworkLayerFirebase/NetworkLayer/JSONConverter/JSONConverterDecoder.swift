import Foundation

struct JSONConverterDecoder {
    func convertToModelArray<T: Codable>(_ data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let documents = jsonResponse?["documents"] as? [[String: Any]] else {
            throw ErrorManager.backendError(.dataParsingFailed)
        }

        return try documents.compactMap { document in
            guard let fields = document["fields"] as? [String: Any] else {
                throw ErrorManager.backendError(.dataParsingFailed)
            }
            let convertedFields = fields.compactMapValues { ($0 as? [String: Any])?["stringValue"] as? String }
            let jsonData = try JSONSerialization.data(withJSONObject: convertedFields)
            return try decoder.decode(T.self, from: jsonData)
        }
    }
}
