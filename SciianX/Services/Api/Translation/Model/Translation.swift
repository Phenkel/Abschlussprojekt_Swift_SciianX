//
//  Translation.swift
//  SciianX
//
//  Created by Philipp Henkel on 01.03.24.
//

import Foundation

struct TranslationResponse: Codable {
    let status: String
    let data: Translation
}

struct Translation: Codable {
    let translatedText: String
    let detectedSourceLanguage: DetectedSourceLanguage
}

struct DetectedSourceLanguage: Codable {
    let code, name: String
}
