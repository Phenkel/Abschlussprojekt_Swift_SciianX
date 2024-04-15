//
//  MockMailCheckRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 14.03.24.
//

import Foundation

class MockMailCheckRepository: MailCheckRepository {
    
    func checkEmail(_ mail: String) async throws -> MailCheck {
            switch mail {
            case "valid@mail.com":
                return MailCheck(
                    valid: true,
                    block: false,
                    disposable: false,
                    emailForwarder: false,
                    domain: "mail.com",
                    text: "valid"
                )
            default:
                throw HTTPError.notFound
            }
        }
}
