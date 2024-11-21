import UIKit

class ViewController: UIViewController {
    
    private let firebaseService = FirebaseService()
    
    // Email and Password Text Fields
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // Buttons
    lazy var loginButton: UIButton = createButton(title: "Login", backgroundColor: .green, action: #selector(loginUser))
    lazy var registerButton: UIButton = createButton(title: "Register", backgroundColor: .orange, action: #selector(registerUser))
    lazy var createButton: UIButton = createButton(title: "Create Document", backgroundColor: .blue, action: #selector(createDocumentAction))
    lazy var readButton: UIButton = createButton(title: "Read Documents", backgroundColor: .purple, action: #selector(fetchDocumentsAction))
    lazy var updateButton: UIButton = createButton(title: "Update Document", backgroundColor: .magenta, action: #selector(updateDocumentAction))
    lazy var deleteButton: UIButton = createButton(title: "Delete Document", backgroundColor: .red, action: #selector(deleteDocumentAction))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    func createButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func addSubviews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(createButton)
        view.addSubview(readButton)
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
    }
    
    func addConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        readButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            
            createButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 250),
            
            readButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 10),
            readButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readButton.heightAnchor.constraint(equalToConstant: 50),
            readButton.widthAnchor.constraint(equalToConstant: 250),
            
            updateButton.topAnchor.constraint(equalTo: readButton.bottomAnchor, constant: 10),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.widthAnchor.constraint(equalToConstant: 250),
            
            deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 10),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc func loginUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        firebaseService.loginUser(email: email, password: password) { result in
            switch result {
            case .success:
                print("User logged in successfully.")
            case .failure(let error):
                print("Login failed: \(error)")
            }
        }
    }
    
    @objc func registerUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        firebaseService.registerUser(email: email, password: password) { result in
            switch result {
            case .success:
                print("User registered successfully.")
            case .failure(let error):
                print("Registration failed: \(error)")
            }
        }
    }
    
    @objc func createDocumentAction() {
        guard firebaseService.isUserAuthenticated() else { return }
        let data: [String: Any] = ["name": "Test User", "age": 30]
        firebaseService.createDocument(collection: "users", data: data) { result in
            switch result {
            case .success:
                print("Document created successfully.")
            case .failure(let error):
                print("Error creating document: \(error)")
            }
        }
    }
    
    @objc func fetchDocumentsAction() {
        guard firebaseService.isUserAuthenticated() else { return }
        firebaseService.fetchDocuments(collection: "users") { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    print("Document ID: \(document.documentID), Data: \(document.data())")
                }
            case .failure(let error):
                print("Error fetching documents: \(error)")
            }
        }
    }
    
    @objc func updateDocumentAction() {
        guard firebaseService.isUserAuthenticated() else { return }
        let documentID = "document-id" // Replace with a valid document ID
        let data: [String: Any] = ["name": "Updated User"]
        firebaseService.updateDocument(collection: "users", documentID: documentID, data: data) { result in
            switch result {
            case .success:
                print("Document updated successfully.")
            case .failure(let error):
                print("Error updating document: \(error)")
            }
        }
    }
    
    @objc func deleteDocumentAction() {
        guard firebaseService.isUserAuthenticated() else { return }
        let documentID = "document-id" // Replace with a valid document ID
        firebaseService.deleteDocument(collection: "users", documentID: documentID) { result in
            switch result {
            case .success:
                print("Document deleted successfully.")
            case .failure(let error):
                print("Error deleting document: \(error)")
            }
        }
    }
}
