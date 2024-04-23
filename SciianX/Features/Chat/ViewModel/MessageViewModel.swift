//
//  MessageViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 17.04.24.
//

import Foundation
import SwiftUI

class MessageViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var text: String?
    @Published private(set) var image: UIImage?
    
    let sender: String
    let createdAt: Date
    let createdAtString: String
    let id: String
    
    private let chatId: String
    private let receiverPublicKey: Data
    private let cryptoKitHelper = CryptoKitHelper.shared
    private let chatRepository = FirebaseChatRepository.shared
    
    init(_ message: ChatMessage, chatId: String, receiverPublicKey: Data) {
        self.id = message.id
        self.sender = message.sender
        self.createdAt = message.createdAt
        self.createdAtString = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy HH:mm"
            return formatter.string(from: message.createdAt)
        }()
        self.chatId = chatId
        
        self.receiverPublicKey = receiverPublicKey
        
        if let encodedText = message.encryptedText {
            do {
                self.text = try self.cryptoKitHelper.decryptText(encodedString: encodedText, publicKey: self.receiverPublicKey)
            } catch {
                print("Failed to decrypt text: \(error)")
            }
        }
        if let encryptedImageUrl = message.imageDataId {
            self.chatRepository.getImageData(encryptedImageUrl, withChatId: self.chatId) { result in
                switch result {
                case .success(let encryptedImageData):
                    do {
                        let decryptedImageData = try self.cryptoKitHelper.decryptImage(encryptedData: encryptedImageData, publicKey: self.receiverPublicKey)
                        self.image = UIImage(data: decryptedImageData)
                    } catch {
                        print("Failed to decrypt image: \(error)")
                    }
                case .failure(let error):
                    print("Failed fetching image: \(error)")
                }
            }
        }
    }
}
