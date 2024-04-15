//
//  TranslationRepositoryTests.swift
//  SciianXTests
//
//  Created by Philipp Henkel on 14.03.24.
//

import XCTest
@testable import SciianX

final class TranslationRepositoryTests: XCTestCase {

    func testTranslateSuccess() async {
        let repository = TranslationRepository.shared
        var response: TranslationResponse?
        
        response = try? await repository.translateText("Test Übersetzung")
        
        XCTAssertNotNil(response)
    }
    
    func testTranslateFailure() async {
        let repository = TranslationRepository.shared
        var response: TranslationResponse?
        
        response = try? await repository.translateText("")
        
        XCTAssertNil(response)
    }
}
