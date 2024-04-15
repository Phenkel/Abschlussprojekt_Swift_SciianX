//
//  ApiManager.swift
//  SciianX
//
//  Created by Philipp Henkel on 04.03.24.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    let xRapidApiKey = "c2f07c81a1msha6f1543ac98dd5fp1f3425jsnaa46c190a646"
    
    func checkApiResponse(_ response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return response.data
        case 400:
            throw HTTPError.badRequest
        case 401:
            throw HTTPError.unauthorized
        case 402:
            throw HTTPError.paymentRequired
        case 403:
            throw HTTPError.forbidden
        case 404:
            throw HTTPError.notFound
        case 413:
            throw HTTPError.requestEntityTooLarge
        case 422:
            throw HTTPError.unprocessableEntity
        default:
            throw HTTPError.http(httpResponse.statusCode)
        }
    }
}
