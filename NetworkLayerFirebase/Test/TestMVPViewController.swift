//
//  TestMVPViewController.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import UIKit
import RouteComposer


protocol TestMVPDisplayLogic: AnyObject {
    @MainActor
    func displayUseCaseSuccess(with viewModel: TestMVPDataFlow.UseCase.ViewModelSuccess)
    @MainActor
    func displayUseCaseFailure(with viewModel: TestMVPDataFlow.UseCase.ViewModelFailure)
}

// MARK: -

final class TestMVPViewController: UIViewController {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: TestMVPPresentationLogic!
    
    private(set) var context: TestMVPFactory.Context = nil
    private let service: ServiceProtocol
    lazy var contentView: DisplaysTestMVP = TestMVPView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        service = Service()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Some title"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
        contentView.viewDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TestMVPViewController: TestMVPDisplayLogic {
    func displayUseCaseSuccess(with viewModel: TestMVPDataFlow.UseCase.ViewModelSuccess) {
        //
        // display successful state on View
        //
    }

    func displayUseCaseFailure(with viewModel: TestMVPDataFlow.UseCase.ViewModelFailure) {
        //
        // Handle failful scenario on UI if neccessary
        //
    }
}

extension TestMVPViewController: ContextAccepting {
    func setup(with context: TestMVPFactory.Context) throws {
        self.context = context
    }
}

extension TestMVPViewController: DismissibleWithRuntimeStorage {
    typealias DismissalTargetContext = Any?
}

extension TestMVPViewController: TestMVPViewDelegate {
    func testViewDidTapAuthorization(_ view: TestMVPView) {

    }
    
    func testViewDidTapRegistration(_ view: TestMVPView) {
        
    }
    
    func testViewDidTapGet(_ view: TestMVPView) {
        Task {
            let userInfos = await service.fetchData(method: .get)
            for userInfo in userInfos {
                print("Name: \(userInfo.name), Age: \(userInfo.age), Email: \(userInfo.email)")
            }
        }
    }

    func testViewDidTapPost(_ view: TestMVPView) {
        Task {
            let userModel = UserInfo(name: "Vladislav", age: "30", email: "vlad@mail.ru")
            let isSuccess = await service.createUser(method: .post, model: userModel)
            if isSuccess {
                print("User created successfully!")
            } else {
                print("Failed to create user.")
            }
        }
    }
    
    func testViewDidTapPut(_ view: TestMVPView) {

    }
    
    func testViewDidTapDelete(_ view: TestMVPView) {

    }
}


private extension TestMVPViewController {
}
