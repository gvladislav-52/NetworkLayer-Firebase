//
//  TestMVPPresenter.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import Foundation

protocol TestMVPPresentationLogic {
    func presentUseCase(with response: TestMVPDataFlow.UseCase.Request)
}

// MARK: -

struct TestMVPPresenter {
    private weak var viewController: TestMVPDisplayLogic?
    private let provider: ProvidesTestMVP

    init(viewController: TestMVPDisplayLogic, provider: ProvidesTestMVP) {
        self.viewController = viewController
        self.provider = provider
    }
}

extension TestMVPPresenter: TestMVPPresentationLogic {
    func presentUseCase(
        with response: TestMVPDataFlow.UseCase.Request
    ) { Task {
        do {
            // Prepare context using request to call provider, database, or file manager
            //
            let _ = try await provider.fetchContent()
            //
            // Make SomeViewModel using provided Data
            //
            await viewController?.displayUseCaseSuccess(with: TestMVPDataFlow.UseCase.ViewModelSuccess())
        } catch {
            // Translate raw Error to ErrorViewModel if it requires custom handling
            //
            await viewController?.displayUseCaseFailure(with: error)
        }
    }}
}
