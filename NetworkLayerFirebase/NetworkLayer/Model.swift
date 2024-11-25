//
//  Model.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

protocol DecodableModel {
    init?(fields: [String: Any])
}

struct UserInfo: DecodableModel {
    let name: String
    let age: String
    let email: String

    init?(fields: [String: Any]) {
        guard let name = (fields["name"] as? [String: Any])?["stringValue"] as? String,
              let age = (fields["age"] as? [String: Any])?["stringValue"] as? String,
              let email = (fields["email"] as? [String: Any])?["stringValue"] as? String else {
            return nil
        }
        self.name = name
        self.age = age
        self.email = email
    }
}
