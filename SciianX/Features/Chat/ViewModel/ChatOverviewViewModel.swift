//
//  ChatViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 18.03.24.
//

import Foundation

class ChatOverviewViewModel: ObservableObject {
    
    @Published var allChats: [ChatViewModel] = []
    
    private let chatRepository = FirebaseChatRepository.shared
    private var allUsers: [UserProfile] = []
    private var userId: String?
    
    init(_ user: UserProfile?, allUsers: [UserProfile]) {
        if let id = user?.id {
            self.fetchAllChats(userId: id)
        }
        self.allUsers = allUsers
        self.userId = user?.id
    }
    
    func updateUsers(user: UserProfile, users: [UserProfile]) {
        self.allUsers = users
        self.userId = user.id
        
        for chat in self.allChats {
            let users = self.allUsers.filter { chat.users.compactMap { $0.id }.contains($0.id) }
            chat.updateUsers(users)
        }
    }
    
    func getChat(receiver: String, userId: String) -> ChatViewModel {
        return if let chat = self.allChats.first(where: { $0.users.contains(where: { $0.id == receiver }) && $0.users.contains(where: { $0.id == userId }) }) {
            chat
        } else {
            self.createChat(userId, receiver)
        }
    }
    
    private func createChat(_ userId1: String, _ userId2: String) -> ChatViewModel {
        let users = self.allUsers.filter { [userId1, userId2].contains($0.id) }
        let chat = Chat(users: [userId1, userId2], messages: [], lastActiveAt: Date())
        
        self.allChats.append(ChatViewModel(chat, users: users, userId: users.first(where: { $0.id == self.userId })?.id ?? ""))
        self.chatRepository.createChat(chat)
        
        return allChats.first(where: { $0.id == chat.id }) ?? ChatViewModel(chat, users: users, userId: users.first(where: { $0.id == self.userId })?.id ?? "")
    }
    
    private func fetchAllChats(userId: String) {
        self.chatRepository.getAllChats() { result in
            switch result {
            case .success(let chats):
                for chat in chats {
                    if !self.allChats.contains(where: { $0.id == chat.id }) {
                        let users = self.allUsers.filter { chat.users.contains($0.id) }
                        self.allChats.append(ChatViewModel(chat, users: users, userId: users.first(where: { $0.id == self.userId })?.id ?? ""))
                    } else {
                        if let chatViewModel = self.allChats.first(where: { $0.id == chat.id }) {
                            chatViewModel.update(chat)
                        }
                    }
                }
            case .failure(let error):
                print("Failed fetching chats: \(error)")
            }
        }
    }
}
