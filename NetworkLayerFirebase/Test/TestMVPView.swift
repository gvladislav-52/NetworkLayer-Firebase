//
//  TestMVPView.swift
//  NetworkLayerFirebase
//
//  Created by gvladislav-52 on 21.11.2024.
//

import UIKit

protocol DisplaysTestMVP: UIView {
    var viewDelegate: TestMVPViewDelegate? { get set }
}

protocol TestMVPViewDelegate: AnyObject {
    func testViewDidTapAuthorization(_ view: TestMVPView)
    func testViewDidTapRegistration(_ view: TestMVPView)
    
    func testViewDidTapGet(_ view: TestMVPView)
    func testViewDidTapPost(_ view: TestMVPView)
    func testViewDidTapPut(_ view: TestMVPView)
    func testViewDidTapDelete(_ view: TestMVPView)
}


// MARK: -

final class TestMVPView: UIView {
    weak var viewDelegate: TestMVPViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubviews()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var authorizationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authorization", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .blue
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else {
                return
            }
            viewDelegate?.testViewDidTapAuthorization(self)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Registration", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .blue
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else {
                return
            }
            viewDelegate?.testViewDidTapRegistration(self)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var getButton: UIButton = {
        let button = UIButton()
        button.setTitle("GET", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else {
                return
            }
            viewDelegate?.testViewDidTapGet(self)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("POST", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .red
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else {
                return
            }
            viewDelegate?.testViewDidTapPost(self)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var putButton: UIButton = {
        let button = UIButton()
        button.setTitle("PUT", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .orange
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else {
                return
            }
            viewDelegate?.testViewDidTapPut(self)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("DELETE", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .purple
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else {
                return
            }
            viewDelegate?.testViewDidTapDelete(self)
        }, for: .touchUpInside)
        return button
    }()
    
   internal private(set) var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "EmailAdress"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    internal private(set) var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
}

extension TestMVPView: DisplaysTestMVP {
}

private extension TestMVPView {
    func addSubviews() {
        addSubview(loginTextField)
        addSubview(passwordTextField)
        
        addSubview(authorizationButton)
        addSubview(registrationButton)
        
        addSubview(stackView)
        stackView.addArrangedSubview(getButton)
        stackView.addArrangedSubview(postButton)
        stackView.addArrangedSubview(putButton)
        stackView.addArrangedSubview(deleteButton)
    }

    func addConstraints() {
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            loginTextField.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            authorizationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authorizationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            authorizationButton.heightAnchor.constraint(equalToConstant: 50),
            authorizationButton.widthAnchor.constraint(equalToConstant: 120),
            
            registrationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            registrationButton.widthAnchor.constraint(equalToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: centerYAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
