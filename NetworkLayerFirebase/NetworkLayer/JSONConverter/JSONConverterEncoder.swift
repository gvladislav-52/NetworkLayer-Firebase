//
//  JSONConverter.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct JSONConverterEncoder {
    func convertToJSON(data: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: data)
    }
}
