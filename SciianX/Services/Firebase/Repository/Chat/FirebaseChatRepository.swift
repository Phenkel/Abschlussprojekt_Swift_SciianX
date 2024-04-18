//
//  FirebaseChatRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.04.24.
//

import Foundation
import FirebaseFirestore

class FirebaseChatRepository {
    
    static let shared = FirebaseChatRepository()
    
    private var allChatListener: ListenerRegistration?
    
    private init() {}
    
    func createChat(_ chat: Chat) {
        // MARK: UPDATE USER
        do {
            try FirebaseManager.shared.firestore.collection("chats").document().setData(from: chat)
        } catch {
            print("Create chat failed: \(error)")
        }
    }
    
    func sendMessage(_ text: String, userId: String, chat: Chat) {
        // MARK: UPDATE USER
        let message = ChatMessage(sender: userId, text: text, createdAt: Date())
        let chat = chat.copy {
            $0.messages.append(message)
        }
        
        do {
            if let id = chat.id {
                try FirebaseManager.shared.firestore.collection("chats").document(id).setData(from: chat, merge: true)
            }
        } catch {
            print("Create message failed: \(error)")
        }
    }
    
    func getAllChats(completion: @escaping (Result<[Chat], FirebaseError>) -> Void) {
        self.allChatListener = FirebaseManager.shared.firestore.collection("chats").addSnapshotListener { querySnapshot, error in
            if let error {
                print("Fetch chats failed: \(error)")
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Query Snapshot has no documents")
                completion(.failure(.collectioNotFound))
                return
            }
            
            let allChats = documents.compactMap { document in
                try? document.data(as: Chat.self)
            }
            
            completion(.success(allChats))
        }
    }
}
