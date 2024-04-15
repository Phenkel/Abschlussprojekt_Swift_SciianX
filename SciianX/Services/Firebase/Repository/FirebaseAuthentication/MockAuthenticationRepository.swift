//
//  MockAuthenticationRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 14.03.24.
//

import Foundation

class MockAuthenticationRepository: AuthenticationRepository {
    
    func login(email: String, password: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        // Simulate a successful login
        if email == "valid@mail.com" && password == "validPassword" {
            let userProfile = UserProfile(
                id: "1",
                email: email,
                realName: "John Doe",
                userName: "johndoe",
                registeredAt: Date(),
                lastActiveAt: Date(),
                following: [],
                followedBy: [],
                image: "",
                description: ""
            )
            completion(.success(userProfile))
        } else {
            
            // Simulate a failed login
            completion(.failure(.unknown(NSError(domain: "com.example.auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Login failed"]))))
        }
    }
    
    func register(email: String, password: String, realName: String, userName: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        // Simulate a successful registration
        if email == "valid@mail.com" && password == "validPassword" {
            
            // Simulate the login after successful registration
            self.login(email: email, password: password) { result in
                completion(result)
            }
        } else {
            
            // Simulate a failed registration
            completion(.failure(.unknown(NSError(domain: "com.example.auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Registration failed"]))))
        }
    }
    
    func logout(completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        // MARK: No Tests
    }
    
    func checkAuth(completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void) {
        // MARK: No Tests
    }
    
    func fetchAllUsers(completion: @escaping (Result<[UserProfile], FirebaseError>) -> Void) {
        // MARK: No Tests
    }
    
    
}
