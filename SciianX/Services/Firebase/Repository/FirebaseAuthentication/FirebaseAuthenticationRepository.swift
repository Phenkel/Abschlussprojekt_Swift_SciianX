//
//  FirebaseRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 05.03.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthenticationRepository: AuthenticationRepository {
    
    var user: User?
    
    static let shared = FirebaseAuthenticationRepository()
    
    private var userListener: ListenerRegistration?
    private var allUsersListener: ListenerRegistration?
    
    private let cryptoKitHelper = CryptoKitHelper.shared
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // AuthErrorCode.code versucht den spezifischen numerischen Error Code aus der Enumeration zu extrahieren
                // RawValue wird benötigt um den spezifischen Case zu identifizieren da AuthError.Code nicht direkt verglichen werden kann
                if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errorCode {
                    case .userNotFound:
                        print("Login failed: \(error)")
                        completion(.failure(.userNotFound))
                    case .accountExistsWithDifferentCredential:
                        print("Login failed: \(error)")
                        completion(.failure(.differentCredentials))
                    default:
                        print("Login failed: \(error)")
                        completion(.failure(.unknown(error)))
                    }
                } else {
                    print("Login failed: \(error)")
                    completion(.failure(.unknown(error)))
                }
                return
            }
            
            guard let authResult = authResult, let email = authResult.user.email else {
                completion(.failure(.userNotFound))
                return
            }
            
            print("User (\(email) logged in -> \(authResult.user.uid)")
            self.user = authResult.user
            
            self.fetchUserProfile(withId: authResult.user.uid) { result in
                completion(result)
            }
        }
    }
    
    func register(email: String, password: String, realName: String, userName: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        print("Register failed: \(error)")
                        completion(.failure(.emailAlreadyRegistered))
                        return
                    case .invalidEmail:
                        print("Register failed: \(error)")
                        completion(.failure(.unvalidMail))
                        return
                    default:
                        print("Register failed: \(error)")
                        completion(.failure(.unknown(error)))
                        return
                    }
                }
            }
            
            guard let authResult, let email = authResult.user.email else {
                completion(.failure(.unknown(nil)))
                return
            }
            
            print("User (\(email)) registered -> \(authResult.user.uid)")
            self.createUserProfile(
                withId: authResult.user.uid,
                email: email,
                realName: realName,
                userName: userName
            )
            
            self.login(email: email, password: password) { result in
                completion(result)
            }
        }
    }
    
    func logout(completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        do {
            try FirebaseManager.shared.auth.signOut()
            self.user = nil
            self.userListener?.remove()
            print("User logged out")
            completion(.success(nil))
        } catch {
            print("Signing out failed: \(error)")
            completion(.failure(.unknown(error)))
        }
    }
    
    func checkAuth(completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        guard let currentUser = FirebaseManager.shared.auth.currentUser else {
            print("No user logged in")
            completion(.failure(.noUserLoggedIn))
            return
        }
        
        self.user = currentUser
        self.fetchUserProfile(withId: currentUser.uid) { result in
            completion(result)
        }
    }
    
    // MARK: DELETE ALL ACTIVITIES
    func deleteUser(withId id: String) {
        FirebaseManager.shared.auth.currentUser?.delete()
        
        FirebaseManager.shared.firestore.collection("users").document(id).delete() { error in
            if let error {
                print("Deleting user -> \(id) failed: \(error)")
            } else {
                print("User -> \(id) deleted")
            }
        }
    }
    
    func fetchAllUsers(completion: @escaping (Result<[UserProfile], FirebaseError>) -> Void) {
        self.allUsersListener = FirebaseManager.shared.firestore.collection("users").addSnapshotListener { querySnapshot, error in
            if let error {
                print("Fetch users failed: \(error)")
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Query Snapshot has no documents")
                completion(.failure(.collectioNotFound))
                return
            }
            
            let allUsers = documents.compactMap { document in
                try? document.data(as: UserProfile.self)
            }
            
            completion(.success(allUsers))
        }
    }
    
    
    private func fetchUserProfile(withId id: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        self.userListener = FirebaseManager.shared.firestore.collection("users").document(id).addSnapshotListener { documentSnapshot, error in
            if let error {
                print("Fetch user failed: \(error)")
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let document = documentSnapshot else {
                print("Document Snapshot not found")
                completion(.failure(.userNotFound))
                return
            }
            
//            let user = try? document.data(as: UserProfile.self)
//            print(id)
//            print(user)
//
//            completion(.success(user))
            
            do {
                let user = try document.data(as: UserProfile.self)
                completion(.success(user))
            } catch {
                print("Fetch user failed: \(error)")
                completion(.failure(.unknown(error)))
            }
        }
    }
    
    private func createUserProfile(withId id: String, email: String, realName: String, userName: String) {
        let userProfile = UserProfile(
            id: id,
            email: email,
            realName: realName,
            userName: userName,
            registeredAt: Date(),
            lastActiveAt: Date(),
            following: [],
            followedBy: [],
            image: "",
            description: "",
            publicKey: self.cryptoKitHelper.exportPublicKeyAsData()
        )
        
        do {
            try FirebaseManager.shared.firestore.collection("users").document(userProfile.id).setData(from: userProfile)
        } catch {
            print("Create user failed: \(error)")
        }
    }
}
