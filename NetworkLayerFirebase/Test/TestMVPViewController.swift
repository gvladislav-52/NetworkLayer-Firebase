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
        Task {
            do {
                guard let login = view.loginTextField.text,
                      let password = view.passwordTextField.text else {
                    return
                }
                try await service.getAuthToken(email: login, password: password)
                print("Авторизация успешна")
            } catch {
                print("Ошибка авторизации: \(error.localizedDescription)")
            }
        }
    }

    func testViewDidTapRegistration(_ view: TestMVPView) {
        
    }
    
    func testViewDidTapGet(_ view: TestMVPView) {
        Task {
            do {
                let userInfos = try await service.fetchData(method: .get)
                
                for document in userInfos.documents {
                        print("Name: \(document.fields.name.stringValue), Age: \(document.fields.age.stringValue), Email: \(document.fields.email.stringValue)")
                }
            } catch let error as NSError {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    func testViewDidTapPost(_ view: TestMVPView) {
        let ageValue = StringValue(stringValue: "30")
        let emailValue = StringValue(stringValue: "user@example.com")
        let nameValue = StringValue(stringValue: "John Doe")
        let fields = Fields(age: ageValue, email: emailValue, name: nameValue)
        let document = Document(name: "test_document_1", fields: fields)
        let firebaseResponse = TestModel(documents: [document])

        Task {
            do {
                let success = try await service.createUser(method: .post, model: firebaseResponse)

                if success {
                    print("User successfully created")
                } else {
                    print("Failed to create user")
                }
            } catch let error as NSError {
                print("Error creating user: \(error.localizedDescription)")
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
