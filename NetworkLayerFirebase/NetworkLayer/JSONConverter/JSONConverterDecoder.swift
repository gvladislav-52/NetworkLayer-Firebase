//
//  JSONConverterDecoder.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

protocol JSONConverterDecoderProtocol {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

struct JSONConverterDecoder: JSONConverterDecoderProtocol {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            throw ErrorManager.backendError(.dataParsingFailed)
        }
    }
}


