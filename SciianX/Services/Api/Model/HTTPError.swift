//
//  HTTPError.swift
//  SciianX
//
//  Created by Philipp Henkel on 01.03.24.
//

import Foundation

enum HTTPError: Error, LocalizedError {
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case requestEntityTooLarge
    case unprocessableEntity
    case http(_ statusCode: Int)
    case invalidUrl
    
    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .paymentRequired:
            return "Payment required"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .requestEntityTooLarge:
            return "Request entity too large"
        case .unprocessableEntity:
            return "Unprocessable entity"
        case .http(let statusCode):
            return "HTTP request failed with status code \(statusCode)"
        case .invalidUrl:
            return "URL is invalid"
        }
    }
}
