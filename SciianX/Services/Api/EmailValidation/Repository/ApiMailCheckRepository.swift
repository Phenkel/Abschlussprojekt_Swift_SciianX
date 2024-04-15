//
//  MailCheckRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 01.03.24.
//

import Foundation

class ApiMailCheckRepository: MailCheckRepository {
    
    static let shared = ApiMailCheckRepository()
    
    private init() {}
    
    func checkEmail(_ mail: String) async throws -> MailCheck {
        guard let url = URL(string: "https://mailcheck.p.rapidapi.com/?domain=\(mail)") else {
            throw HTTPError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(ApiManager.shared.xRapidApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        
        let response = try await URLSession.shared.data(for: urlRequest)
        
        let data = try ApiManager.shared.checkApiResponse(response)
        
        return try JSONDecoder().decode(MailCheck.self, from: data)
    }
}
