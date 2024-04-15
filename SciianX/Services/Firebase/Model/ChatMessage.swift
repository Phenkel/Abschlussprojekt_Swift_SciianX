//
//  ChatMessage.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.04.24.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    
    let sender: String
    let text: String
    let createdAt: Date
}
