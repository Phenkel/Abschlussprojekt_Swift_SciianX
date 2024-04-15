//
//  FirebaseError.swift
//  SciianX
//
//  Created by Philipp Henkel on 11.03.24.
//

import Foundation

enum FirebaseError: Error, LocalizedError {
    case userNotFound
    case collectioNotFound
    case documentNotFound
    case differentCredentials
    case emailAlreadyRegistered
    case unvalidMail
    case noUserLoggedIn
    case unknown(_ error: Error?)
    
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User not found"
        case .collectioNotFound:
            return "Collection not found"
            case .documentNotFound:
            return "Document not found"
        case .differentCredentials:
            return "Mail and Password are not matching"
        case .emailAlreadyRegistered:
            return "A user with this email already exists."
        case .unvalidMail:
            return "Email is unvalid."
        case .noUserLoggedIn:
            return "No user logged in"
        case .unknown(let error):
            return """
            An error occured. Please try again later or contact support if the error persists.
            \(error?.localizedDescription ?? "No error message found")
            """
        }
    }
}
