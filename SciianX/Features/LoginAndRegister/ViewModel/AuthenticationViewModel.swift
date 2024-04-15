//
//  AuthenticationViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 11.03.24.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    
    @Published private(set) var user: UserProfile?
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var allUsers: [UserProfile] = []
    
    private var mailCheckRepository: MailCheckRepository
    private var authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository, mailCheckRepository: MailCheckRepository) {
        self.authenticationRepository = authenticationRepository
        self.mailCheckRepository = mailCheckRepository
        
        self.authenticationRepository.checkAuth() { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
        self.fetchAllUsers()
    }
    
    func login(mail: String, password: String) {
        self.errorMessage = ""
        
        self.authenticationRepository.login(email: mail, password: password) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func register(mail: String, password: String, passwordConfirm: String, realName: String, userName: String) {
        self.errorMessage = ""
        
        guard !mail.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty, !realName.isEmpty, !userName.isEmpty else {
            self.errorMessage = "Please fill out every field."
            return
        }
        
        guard password == passwordConfirm else {
            self.errorMessage = "Passwords don't match."
            return
        }
        
        let passwordRegex = "^(?=.{6,}).*$"
        guard password.range(of: passwordRegex, options: .regularExpression) != nil else {
            self.errorMessage = "Password needs at least 6 characters"
            return
        }
        
        guard !allUsers.contains(where: { $0.userName.lowercased() == userName.lowercased() }) else {
            self.errorMessage = "Username is already in use"
            return
        }
        
        Task {
            do {
                let mailCheck = try await mailCheckRepository.checkEmail(mail)
                
                if mailCheck.valid, !mailCheck.block, !mailCheck.disposable, !mailCheck.emailForwarder {
                    authenticationRepository.register(email: mail, password: password, realName: realName, userName: userName) { result in
                        switch result {
                        case .success(let user):
                            self.user = user
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                } else {
                    self.errorMessage = mailCheck.text
                }
            } catch {
                self.errorMessage = "Could not validate eMail"
                print("Failed validating email: \(error)")
            }
        }
    }
    
    func logout() {
        self.authenticationRepository.logout() { result in
            switch result {
            case .success:
                self.user = nil
            case .failure(let error):
                print("Failed logging out: \(error)")
            }
        }
    }
    
    func getUserContacts(withUserId: String) -> [UserProfile] {
        return self.allUsers.filter { $0.following.contains(withUserId) }
    }
    
//    func getXplore(_ search: String) -> [UserProfile] {
//        guard !search.isEmpty else { return self.allUsers }
//        return self.allUsers.filter { $0.userName.lowercased().contains(search.lowercased()) || $0.realName.lowercased().contains(search.lowercased()) }
//    }
    
    private func fetchAllUsers() {
        self.authenticationRepository.fetchAllUsers() { result in
            switch result {
            case .success(let users):
                self.allUsers = users.sorted(by: { $0.lastActiveAt > $1.lastActiveAt })
            case .failure(let error):
                print("Failed fetching users: \(error)")
            }
        }
    }
}
