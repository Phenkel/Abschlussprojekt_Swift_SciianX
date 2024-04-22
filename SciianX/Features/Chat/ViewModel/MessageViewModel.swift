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
    let id: String
    
    private let receiverPublicKey: Data
    private let cryptoKitHelper = CryptoKitHelper.shared
    
    init(_ message: ChatMessage, receiverPublicKey: Data) {
        self.receiverPublicKey = receiverPublicKey
        
        if let textData = message.textData {
            do {
                self.text = try self.cryptoKitHelper.decryptText(encryptedData: textData, publicKey: self.receiverPublicKey)
            } catch {
                print("Failed to decrypt text: \(error)")
            }
        }
        if let imageData = message.imageData {
            do {
                let decryptedImageData = try self.cryptoKitHelper.decryptImage(encryptedData: imageData, publicKey: self.receiverPublicKey)
                self.image = UIImage(data: decryptedImageData)
            } catch {
                print("Failed to decrypt image: \(error)")
            }
        }
        
        self.id = message.id
        self.sender = message.sender
        self.createdAt = message.createdAt
    }
}
