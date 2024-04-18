//
//  MessageViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 17.04.24.
//

import Foundation
import SwiftUI

class MessageViewModel: ObservableObject {
    
    @Published private(set) var text: String?
    @Published private(set) var image: UIImage?
    
    let sender: String
    let createdAt: Date
    
    private let id: String
    private let receiverPublicKey: Data
    private let cryptoKitHelper = CryptoKitHelper.shared
    
    init(_ message: ChatMessage, receiverPublicKey: Data) {
        self.receiverPublicKey = receiverPublicKey
        
        if let textData = message.textData {
            self.text = try? self.cryptoKitHelper.decryptText(encryptedData: textData, publicKey: self.receiverPublicKey)
        }
        if let imageData = message.imageData {
            if let decryptedImageData = try? self.cryptoKitHelper.decryptImage(encryptedData: imageData, publicKey: self.receiverPublicKey) {
                self.image = UIImage(data: decryptedImageData)
            }
        }
        
        self.id = message.id
        self.sender = message.sender
        self.createdAt = message.createdAt
    }
}
