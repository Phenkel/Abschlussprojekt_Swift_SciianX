//
//  Chat.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.04.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable {
    @DocumentID var id: String?
    
    let users: [String]
    let messages: [ChatMessage]
}
