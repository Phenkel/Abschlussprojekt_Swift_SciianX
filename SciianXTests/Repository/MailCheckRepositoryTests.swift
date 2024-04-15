//
//  MailCheckRepositoryTests.swift
//  SciianXTests
//
//  Created by Philipp Henkel on 14.03.24.
//

import XCTest
@testable import SciianX

final class MailCheckRepositoryTests: XCTestCase {

    func testMailSuccess() async {
        let repository = ApiMailCheckRepository.shared
        var response: MailCheck?

        response = try? await repository.checkEmail("valid@mail.com")
        
        XCTAssertNotNil(response)
    }
    
    func testMailFailure() async {
        let repository = ApiMailCheckRepository.shared
        var response: MailCheck?

        response = try? await repository.checkEmail("invalid")
    
        XCTAssertNil(response)
    }

}
