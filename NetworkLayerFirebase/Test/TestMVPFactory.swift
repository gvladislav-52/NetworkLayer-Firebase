//
//  TestMVPFactory.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation
import RouteComposer

struct TestMVPFactory: Factory {
    typealias Context = Any?
    typealias ViewController = TestMVPViewController

    func build(with context: Context) throws -> ViewController {
        let provider = TestMVPProvider()
        let viewController = ViewController()
        let presenter = TestMVPPresenter(viewController: viewController, provider: provider)

        viewController.presenter = presenter

        return viewController
    }
}
