//
//  ChatViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.04.24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject, Identifiable {
    
    @Published var users: [UserProfile] = []
    @Published var messages: [MessageViewModel] = []
    @Published var lastActiveAt: Date
    
    let id: String
    
    private var modelMessages: [ChatMessage]
    private let chatRepository = FirebaseChatRepository.shared
    private let userId: String
    
    init(_ chat: Chat, users: [UserProfile], userId: String) {
        self.users = users
        self.lastActiveAt = chat.lastActiveAt
        self.id = chat.id ?? ""
        self.userId = userId
        self.modelMessages = chat.messages
        self.messages = self.modelMessages.compactMap {
            MessageViewModel($0, receiverPublicKey: self.users.first(where: { $0.id != userId })?.publicKey ?? Data())
        }
        
        self.messages.sort { $0.createdAt < $1.createdAt }
    }
    
    //mh@dens-berlin.com
    
    func update(_ chat: Chat) {
        self.lastActiveAt = chat.lastActiveAt
        self.modelMessages = chat.messages
        self.messages = self.modelMessages.compactMap {
            MessageViewModel($0, receiverPublicKey: self.users.first(where: { $0.id != userId })?.publicKey ?? Data())
        }
        
        self.messages.sort { $0.createdAt < $1.createdAt }
    }
    
    func updateUsers(_ users: [UserProfile]) {
        self.users = users
    }
    
    func sendMessage(_ text: String, image: UIImage?, userId: String) {
        self.chatRepository.sendMessage(
            text: !text.isEmpty ? text : nil,
            image: image?.jpegData(compressionQuality: 0.8),
            userId: self.userId,
            chat: self.asChat(),
            publicKey: self.users.first(where: { $0.id != userId })?.publicKey ?? Data()
        )
        print(self.users.first(where: { $0.id != userId })?.publicKey)
    }
    
    private func asChat() -> Chat {
        return Chat(id: self.id, users: self.users.map { $0.id }, messages: self.modelMessages, lastActiveAt: self.lastActiveAt)
    }
}
