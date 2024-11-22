//
//  JSONConverter.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

final class JSONParser {
    func parseJSON(_ data: Data) -> Bool {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Create response: \(jsonResponse)")
                return true
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
        return false
    }
}
