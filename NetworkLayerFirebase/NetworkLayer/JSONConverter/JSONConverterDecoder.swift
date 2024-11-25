//
//  JSONConverterDecoder.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 23.11.2024.
//

import Foundation

struct JSONConverterDecoder {
    func convertToModelArray<T: DecodableModel>(_ data: Data) -> [T]? {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let documents = jsonResponse["documents"] as? [[String: Any]] else {
            return nil
        }

        return documents.compactMap { document in
            guard let fields = document["fields"] as? [String: Any] else {
                return nil
            }
            return T(fields: fields)
        }
    }
}
