//
//  TestMVPConfiguration.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import UIKit
import RouteComposer

enum TestMVPConfiguration {
    static func fromSomeScreen(with context: TestMVPFactory.Context) -> AnyDestination {
         Destination(to: stepFromSomeScreen, with: context).unwrapped()
    }
    
    private static let stepFromSomeScreen: DestinationStep<
        TestMVPViewController, TestMVPFactory.Context
    > = StepAssembly(finder: ClassFinder(), factory: TestMVPFactory())
        .adding(ContextSettingTask())
        .adding(DismissalMethodProvidingContextTask { vc, context, animated, completion in
        })
        .using(UINavigationController.push())
        .assemble(from: GeneralStep.custom(using: ClassFinder(options: .visible)))
}
