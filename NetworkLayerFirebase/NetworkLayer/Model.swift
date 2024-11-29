//
//  Model.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 18.11.2024.
//

import Foundation

struct TestModel: Codable {
    let documents: [Document]
}

struct Document: Codable {
    let name: String
    let fields: Fields
}

struct Fields: Codable {
    let age: StringValue
    let email: StringValue
    let name: StringValue
}

struct StringValue: Codable {
    let stringValue: String
}
