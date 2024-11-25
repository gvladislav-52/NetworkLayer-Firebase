//
//  JSONConverterDecoder.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

struct JSONConverterDecoder {
    func convertToModelArray<T: Decodable>(_ data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ErrorManager.backendError(.dataParsingFailed)
        }
        guard let documents = jsonResponse["documents"] as? [[String: Any]] else {
            throw ErrorManager.backendError(.dataParsingFailed)
        }
        return try documents.compactMap { document in
            guard let fields = document["fields"] as? [String: Any] else {
                throw ErrorManager.backendError(.dataParsingFailed)
            }
            let convertedFields = fields.compactMapValues { field in
                (field as? [String: Any])?["stringValue"] as? String
            }
            let jsonData = try JSONSerialization.data(withJSONObject: convertedFields)
            return try decoder.decode(T.self, from: jsonData)
        }
    }
}

