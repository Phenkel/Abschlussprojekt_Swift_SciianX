//
//  MailCheckRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 14.03.24.
//

import Foundation

protocol MailCheckRepository {
    
    func checkEmail(_ mail: String) async throws -> MailCheck
}
