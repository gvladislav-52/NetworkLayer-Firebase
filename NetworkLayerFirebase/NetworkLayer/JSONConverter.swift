//
//  JSONConverter.swift
//  reportal
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct JSONConverter {
    static func convertToUserInfoArray(_ data: Data) -> [UserInfo]? {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let documents = jsonResponse["documents"] as? [[String: Any]] else {
            return nil
        }

        return documents.compactMap { document in
            guard let fields = document["fields"] as? [String: Any] else {
                return nil
            }
            return convertToUserInfo(fields: fields)
        }
    }
    
    static func convertToUserInfo(fields: [String: Any]) -> UserInfo? {
        guard let name = (fields["name"] as? [String: Any])?["stringValue"] as? String,
              let age = (fields["age"] as? [String: Any])?["stringValue"] as? String,
              let email = (fields["email"] as? [String: Any])?["stringValue"] as? String else {
            return nil
        }
        return UserInfo(name: name, age: age, email: email)
    }
    
    static func convertToJSON(data: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: data)
    }
}
