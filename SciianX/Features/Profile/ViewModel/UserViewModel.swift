//
//  UserViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 26.03.24.
//

import Foundation
import SwiftUI
import PhotosUI

class UserViewModel: ObservableObject {
    
    private(set) var user: UserProfile?
    
    private let userRepository = FirebaseUserRepository.shared
    
    init(_ user: UserProfile?, _ allUsers: [UserProfile]) {
        self.user = user
    }
    
    func followUser(user: UserProfile) {
        if let withUser = self.user {
            self.userRepository.followUser(user, withUser: withUser)
        }
    }
    
    func checkSameUser(_ user: UserProfile?) -> Bool {
        return self.user?.id == user?.id
    }
    
    func updateFirebaseUser(realName: String, description: String, image: UIImage?) {
        Task {
            if let user {
                await self.userRepository.updateFirebaseUser(user, realName: realName, description: description, image: image?.jpegData(compressionQuality: 0.8))
            }
        }
    }
    
    func updateUser(_ user: UserProfile) {
        self.user = user
    }
    
    func convertImagePicker(_ data: PhotosPickerItem?, completion: @escaping (UIImage?) -> Void) {
        Task {
            if let data = try? await data?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    completion(uiImage)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}
