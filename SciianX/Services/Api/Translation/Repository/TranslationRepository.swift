//
//  TranslationRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 01.03.24.
//

import Foundation

class TranslationRepository {
    
    static let shared = TranslationRepository()
    
    private init() {}
    
    func translateText(_ text: String) async throws -> TranslationResponse {
        guard let url = URL(string: "https://text-translator2.p.rapidapi.com/translate") else {
            throw HTTPError.invalidUrl
        }
        
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "X-RapidAPI-Key": ApiManager.shared.xRapidApiKey,
        ]
        
        let postData = "source_language=auto&target_language=\(self.getLanguageCode())&text=\(text)".data(using: .utf8)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = postData
        
        let response = try await URLSession.shared.data(for: urlRequest)
        
        let data = try ApiManager.shared.checkApiResponse(response)
        
        return try JSONDecoder().decode(TranslationResponse.self, from: data)
    }
    
    private func getLanguageCode() -> String {
        let availableLanguageCodes = [
            "af", "sq", "am", "ar", "hy", "az", "eu", "be", "bn", "bs",
            "bg", "ca", "ceb", "ny", "zh-CN", "zh-TW", "co", "hr", "cs",
            "da", "nl", "en", "eo", "et", "tl", "fi", "fr", "fy", "gl",
            "ka", "de", "el", "gu", "ht", "ha", "haw", "iw", "hi", "hmn",
            "hu", "is", "ig", "id", "ga", "it", "ja", "jw", "kn", "kk",
            "km", "rw", "ko", "ku", "ky", "lo", "la", "lv", "lt", "lb",
            "mk", "mg", "ms", "ml", "mt", "mi", "mr", "mn", "my", "ne",
            "no", "or", "ps", "fa", "pl", "pt", "pa", "ro", "ru", "sm",
            "gd", "sr", "st", "sn", "sd", "si", "sk", "sl", "so", "es",
            "su", "sw", "sv", "tg", "ta", "tt", "te", "th", "tr", "tk",
            "uk", "ur", "ug", "uz", "vi", "cy", "xh", "yi", "yo", "zu",
            "he", "zh"
        ]
                
        guard let localLanguageCode = Locale.current.language.languageCode?.identifier, availableLanguageCodes.contains(localLanguageCode) else {
            return "en"
        }
        
        return localLanguageCode
    }
}
