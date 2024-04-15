//
//  FirebaseUserRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 28.03.24.
//

import Foundation

class FirebaseUserRepository {
    
    static let shared = FirebaseUserRepository()
    
    private init() {}
    
    func followUser(_ user: UserProfile, withUser: UserProfile) {
        var updatedUser = user
        var updatedWithUser = withUser
        
        if !user.followedBy.contains(withUser.id) {
            updatedUser = user.copy {
                $0.followedBy.append(withUser.id)
            }
            updatedWithUser = withUser.copy {
                $0.following.append(user.id)
                $0.lastActiveAt = Date()
            }
        } else {
            updatedUser = user.copy {
                $0.followedBy.removeAll(where: { $0 == withUser.id })
            }
            updatedWithUser = withUser.copy {
                $0.following.removeAll(where: { $0 == user.id })
                $0.lastActiveAt = Date()
            }
        }
        
        do {
            try FirebaseManager.shared.firestore.collection("users").document(user.id).setData(from: updatedUser, merge: true)
            try FirebaseManager.shared.firestore.collection("users").document(withUser.id).setData(from: updatedWithUser, merge: true)
        } catch {
            print("Follow user failed: \(error)")
        }
    }
    
    func updateFirebaseUser(_ user: UserProfile, realName: String, description: String, image: Data?) async {
        var updatedUser: UserProfile
        
        if let image {
            if let url = await self.uploadImage(image, withUserId: user.id) {
                updatedUser = user.copy {
                    $0.realName = realName
                    $0.description = description
                    $0.image = url.absoluteString
                }
            } else {
                updatedUser = user.copy {
                    $0.realName = realName
                    $0.description = description
                }
            }
        } else {
            updatedUser = user.copy {
                $0.realName = realName
                $0.description = description
            }
        }
        
        do {
            try FirebaseManager.shared.firestore.collection("users").document(user.id).setData(from: updatedUser, merge: true)
        } catch {
            print("Update profile image failed: \(error)")
        }
    }
    
    private func uploadImage(_ imageData: Data, withUserId id: String) async -> URL? {
        return await withUnsafeContinuation { continuation in
            let imageRef = FirebaseManager.shared.storageRef.child("users/\(id).jpg")
            
            imageRef.putData(imageData) { _, error in
                if let error {
                    print("Failed uploading image: \(error)")
                    continuation.resume(returning: nil)
                }
                
                imageRef.downloadURL { url, error in
                    if let error {
                        print("Failed getting url: \(error)")
                        continuation.resume(returning: nil)
                    }
                    
                    continuation.resume(returning: url)
                }
            }
        }
    }
}
