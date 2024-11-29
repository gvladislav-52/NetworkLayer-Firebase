//
//  TestMVPDataFlow.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

enum TestMVPDataFlow {
    enum UseCase {
        struct Request { }
        struct ViewModelSuccess {
        // let content: SomeViewModel // any type of prepared data to be displayed
        }
        typealias ViewModelFailure = Error // or ErrorViewModel / struct ViewModelFailure
    }
}
