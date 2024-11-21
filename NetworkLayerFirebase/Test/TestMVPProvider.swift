//
//  TestMVPProvider.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

protocol ProvidesTestMVP {
    func fetchContent() async throws -> Data
}

// MARK: -

struct TestMVPProvider: ProvidesTestMVP {
//    let webService: WebServiceProtocol

    func fetchContent() async throws -> Data {
        Data()
    }
}
