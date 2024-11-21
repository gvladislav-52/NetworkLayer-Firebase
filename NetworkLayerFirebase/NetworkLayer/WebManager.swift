import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    
    private let db = Firestore.firestore()
    
    // MARK: - Authentication
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    var currentUserToken: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func isUserAuthenticated() -> Bool {
        return currentUserToken != nil
    }
    
    // MARK: - Firestore CRUD
    
    func createDocument(collection: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchDocuments(collection: String, completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                completion(.success(documents))
            }
        }
    }
    
    func updateDocument(collection: String, documentID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(documentID).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteDocument(collection: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(documentID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
