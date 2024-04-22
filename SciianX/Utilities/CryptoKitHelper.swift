//
//  CryptoKitHelper.swift
//  SciianX
//
//  Created by Philipp Henkel on 16.04.24.
//

import Foundation
import CryptoKit
import KeychainSwift

class CryptoKitHelper {
    
    static let shared = CryptoKitHelper()
    
    private let keychain = KeychainSwift()
    
    private init() {
        self.keychain.synchronizable = true
    }
    
    func exportPublicKeyAsData() -> Data {
        let rawPublicKey = self.getPrivateKey().publicKey.rawRepresentation
        
        return rawPublicKey
    }
    
    func exportPrivateKeyAsString() throws -> String {
        let rawPrivateKey = self.getPrivateKey().rawRepresentation
        let privateKeyBase64 = rawPrivateKey.base64EncodedString()
        guard let percentEncodedPrivateKey = privateKeyBase64.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            throw CryptoError.invalidPrivateKey
        }
        
        return percentEncodedPrivateKey
    }
    
    func importPrivateKeyFromString(_ privateKey: String) throws {
        guard let privateKeyBase64 = privateKey.removingPercentEncoding, let rawPrivateKey = Data(base64Encoded: privateKeyBase64) else {
            throw CryptoError.invalidPrivateKey
        }
        
        self.keychain.set(rawPrivateKey, forKey: "E2EEPrivateKey", withAccess: .accessibleWhenUnlocked)
    }
        
    func encryptText(text: String, publicKey: Data) throws -> Data {
        let publicKey = try self.importPublicKeyFromData(publicKey)
        
        guard let textData = text.data(using: .utf8) else {
            throw CryptoError.textEncoding
        }
        let encryptedData = try ChaChaPoly.seal(textData, using: self.getSymmetricKey(publicKey: publicKey)).combined
        
        return encryptedData
        
//        guard let textData = text.data(using: .utf8) else {
//            throw CryptoError.textEncoding
//        }
//        let encryptedAesGcm = try AES.GCM.seal(textData, using: self.getSymmetricKey(publicKey: publicKey))
//        guard let encryptedData = encryptedAesGcm.combined else {
//            throw CryptoError.encryption
//        }
//        
//        return encryptedData
    }
    
    func decryptText(encryptedData: Data, publicKey: Data) throws -> String {
        let publicKey = try self.importPublicKeyFromData(publicKey)
        
        let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedData)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: self.getSymmetricKey(publicKey: publicKey))
        let text = String(decoding: decryptedData, as: UTF8.self)
        
        return text
        
//        let encryptedAesGcm = try AES.GCM.SealedBox(combined: encryptedData)
//        let decryptedData = try AES.GCM.open(encryptedAesGcm, using: self.getSymmetricKey(publicKey: publicKey))
//        
//        return String(decoding: decryptedData, as: UTF8.self)
    }
    
    func encryptImage(image: Data, publicKey: Data) throws -> Data {
        let publicKey = try self.importPublicKeyFromData(publicKey)
        
        let encryptedData = try ChaChaPoly.seal(image, using: self.getSymmetricKey(publicKey: publicKey))
        
        return encryptedData.combined
    }
    
    func decryptImage(encryptedData: Data, publicKey: Data) throws -> Data {
        let publicKey = try self.importPublicKeyFromData(publicKey)
        
        let encryptedData = try ChaChaPoly.SealedBox(combined: encryptedData)
        let decryptedData = try ChaChaPoly.open(encryptedData, using: self.getSymmetricKey(publicKey: publicKey))
        
        return decryptedData
    }
    
    private func importPublicKeyFromData(_ publicKey: Data) throws -> P256.KeyAgreement.PublicKey {
        let publicKey = try P256.KeyAgreement.PublicKey(rawRepresentation: publicKey)
        
        return publicKey
    }
    
    private func getSymmetricKey(publicKey: P256.KeyAgreement.PublicKey) throws -> SymmetricKey {
        let sharedSecret = try self.getPrivateKey().sharedSecretFromKeyAgreement(with: publicKey)
        
        guard let salt = "Salt for symmetric key".data(using: .utf8) else {
            throw CryptoError.invalidSalt
        }
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: salt,
            sharedInfo: Data(),
            outputByteCount: 32
        )
        
        return symmetricKey
    }
    
    private func getPrivateKey() -> P256.KeyAgreement.PrivateKey {
        if let privateKeyExport = self.keychain.getData("E2EEPrivateKey") {
            guard let privateKey = try? self.importPrivateKeyFromData(privateKeyExport) else {
                let privateKey = P256.KeyAgreement.PrivateKey()
                
                self.keychain.set(self.exportPrivateKeyAsData(privateKey), forKey: "E2EEPrivateKey", withAccess: .accessibleWhenUnlocked)
                
                return privateKey
            }
            
            return privateKey
        } else {
            let privateKey = P256.KeyAgreement.PrivateKey()
            
            self.keychain.set(self.exportPrivateKeyAsData(privateKey), forKey: "E2EEPrivateKey", withAccess: .accessibleWhenUnlocked)
            
            return privateKey
        }
    }
    
    private func exportPrivateKeyAsData(_ privateKey: P256.KeyAgreement.PrivateKey) -> Data {
        let rawPrivateKey = privateKey.rawRepresentation

        return rawPrivateKey
    }
    
    private func importPrivateKeyFromData(_ privateKey: Data) throws -> P256.KeyAgreement.PrivateKey {
        return try P256.KeyAgreement.PrivateKey(rawRepresentation: privateKey)
    }
}

fileprivate enum CryptoError: Error, LocalizedError {
    case invalidPrivateKey, invalidSalt, textEncoding, encryption
    
    var localizedDescription: String {
        switch self {
        case .invalidPrivateKey:
            return "Invalid private key"
        case .invalidSalt:
            return "Invalid salt"
        case .textEncoding:
            return "Text encoding error"
        case .encryption:
            return "Encryption error"
        }
    }
}
