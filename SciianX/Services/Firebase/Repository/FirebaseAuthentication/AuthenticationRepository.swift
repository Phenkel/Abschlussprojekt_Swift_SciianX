//
//  AuthenticationRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 14.03.24.
//

import Foundation

protocol AuthenticationRepository {
    
    func login(email: String, password: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void)
    
    func register(email: String, password: String, realName: String, userName: String, completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void)
    
    func logout(completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void)
    
    func checkAuth(completion: @escaping (Result<UserProfile?, FirebaseError>) -> Void)
    
    func fetchAllUsers(completion: @escaping (Result<[UserProfile], FirebaseError>) -> Void)
}
