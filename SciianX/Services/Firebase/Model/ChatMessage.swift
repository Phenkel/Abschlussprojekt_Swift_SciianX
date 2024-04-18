//
//  ChatMessage.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.04.24.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    var id: String {
        UUID().uuidString
    }
    
    let sender: String
    let textData: Data?
    let imageData: Data?
    let createdAt: Date
}
