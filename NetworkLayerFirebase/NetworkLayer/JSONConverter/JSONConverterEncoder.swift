//
//  JSONConverterEncoder.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct JSONConverterEncoder {
    func convertToJSON(data: [String: Any]) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            throw ErrorManager.internalError(.dataParsingFailed)
        }
    }
}
