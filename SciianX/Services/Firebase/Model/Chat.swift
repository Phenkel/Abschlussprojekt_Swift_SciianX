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
    let lastActiveAt: Date
}

extension Chat {
    func copy(build: (inout Builder) -> Void) -> Chat {
        var builder = Builder(chat: self)
        build(&builder)
        
        return builder.toChat()
    }
    
    struct Builder {
        var id: String?
        var users: [String]
        var messages: [ChatMessage]
        var lastActiveAt: Date
        
        fileprivate init(chat: Chat) {
            self.id = chat.id
            self.users = chat.users
            self.messages = chat.messages
            self.lastActiveAt = chat.lastActiveAt
        }
        
        fileprivate func toChat() -> Chat {
            return Chat(
                id: id,
                users: users,
                messages: messages,
                lastActiveAt: lastActiveAt
            )
        }
    }
}
