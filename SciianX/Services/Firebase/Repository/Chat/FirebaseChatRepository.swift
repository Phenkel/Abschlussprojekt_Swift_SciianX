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
    private let cryptoKitHelper = CryptoKitHelper.shared
    
    private init() {}
    
    func createChat(_ chat: Chat) {
        // MARK: UPDATE USER
        do {
            try FirebaseManager.shared.firestore.collection("chats").document().setData(from: chat)
        } catch {
            print("Create chat failed: \(error)")
        }
    }
    
    func sendMessage(text: String?, image: Data?, userId: String, chat: Chat, publicKey: Data) async {
        var imageDataPath: String?
        if let image, let encryptedImage = try? self.cryptoKitHelper.encryptImage(image: image, publicKey: publicKey) {
            if let id = chat.id {
                await imageDataPath = self.uploadEncryptedImageData(encryptedImage, withChatId: id)
            }
        }
        
        let message = ChatMessage(
            sender: userId,
            encryptedText: text != nil ? try? self.cryptoKitHelper.encryptText(text: text!, publicKey: publicKey) : nil,
            imageDataId: imageDataPath,
            createdAt: Date()
        )
        let chat = chat.copy {
            $0.messages.append(message)
        }
        
        do {
            if let id = chat.id {
                try FirebaseManager.shared.firestore.collection("chats").document(id).setData(from: chat, merge: true) { error in
                    if let error {
                        print("Create message failed: \(error)")
                    }
                }
            }
        } catch {
            print("Create message failed: \(error)")
        }
    }
    
    func getImageData(_ imageId: String, withChatId chatId: String, completion: @escaping (Result<Data, FirebaseError>) -> Void) {
        let localURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(imageId).dat")
        
        do {
            let data = try Data(contentsOf: localURL)
            completion(.success(data))
            return
        } catch {
            FirebaseManager.shared.storageRef.child("chats/\(chatId)/\(imageId).dat").write(toFile: localURL) { url, error in
                if let error {
                    print("Fetch image failed: \(error)")
                    completion(.failure(.unknown(error)))
                    return
                }
                
                if let url {
                    do {
                        let data = try Data(contentsOf: url)
                        completion(.success(data))
                        return
                    } catch {
                        print("Fetch image failed: \(error)")
                        completion(.failure(.unknown(error)))
                        return
                    }
                }
            }
        }
        
//        if FileManager.default.fileExists(atPath: localURL.path) {
//            do {
//                let data = try Data(contentsOf: localURL)
//                completion(.success(data))
//                return
//            } catch {
//                FirebaseManager.shared.storageRef.child("chats/\(chatId)/\(imageId).dat").write(toFile: localURL) { url, error in
//                    if let error {
//                        print("Fetch image failed: \(error)")
//                        completion(.failure(.unknown(error)))
//                        return
//                    }
//                    
//                    if let url {
//                        do {
//                            let data = try Data(contentsOf: url)
//                            completion(.success(data))
//                            return
//                        } catch {
//                            print("Fetch image failed: \(error)")
//                            completion(.failure(.unknown(error)))
//                            return
//                        }
//                    }
//                }
//            }
//        } else {
//            FirebaseManager.shared.storageRef.child("chats/\(chatId)/\(imageId).dat").write(toFile: localURL) { url, error in
//                if let error {
//                    print("Fetch image failed: \(error)")
//                    completion(.failure(.unknown(error)))
//                    return
//                }
//                
//                if let url {
//                    do {
//                        let data = try Data(contentsOf: url)
//                        completion(.success(data))
//                        return
//                    } catch {
//                        print("Fetch image failed: \(error)")
//                        completion(.failure(.unknown(error)))
//                        return
//                    }
//                }
//            }
//        }
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
    
    private func uploadEncryptedImageData(_ imageData: Data, withChatId id: String) async -> String? {
        var imageDataId: String? = "\(UUID().uuidString)"
        return await withUnsafeContinuation { continuation in
            let fileRef = FirebaseManager.shared.storageRef.child("chats/\(id)/\(imageDataId!).dat")
            
            fileRef.putData(imageData) { _, error in
                if let error {
                    print("Failed uploading image: \(error)")
                    imageDataId = nil
                    continuation.resume(returning: imageDataId)
                }
                
                fileRef.downloadURL { url, error in
                    if let error {
                        print("Failed getting url: \(error)")
                        imageDataId = nil
                        continuation.resume(returning: imageDataId)
                    }
                    
                    continuation.resume(returning: imageDataId)
                }
            }
        }
    }
}
