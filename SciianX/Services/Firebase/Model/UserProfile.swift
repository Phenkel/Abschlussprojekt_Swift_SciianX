//
//  UserProfile.swift
//  SciianX
//
//  Created by Philipp Henkel on 05.03.24.
//

import Foundation

struct UserProfile: Codable, Equatable, Identifiable {
    let id: String
    let email: String
    let realName: String
    let userName: String
    let registeredAt: Date
    let lastActiveAt: Date
    let following: [String]
    let followedBy: [String]
    let image: String
    let description: String
}

extension UserProfile {
    func copy(build: (inout Builder) -> Void) -> UserProfile {
        var builder = Builder(userProfile: self)
        build(&builder)
        
        return builder.toUserProfile()
    }
    
    struct Builder {
        var id: String
        var email: String
        var realName: String
        var userName: String
        var registeredAt: Date
        var lastActiveAt: Date
        var following: [String]
        var followedBy: [String]
        var image: String
        var description: String
        
        fileprivate init(userProfile: UserProfile) {
            self.id = userProfile.id
            self.email = userProfile.email
            self.realName = userProfile.realName
            self.userName = userProfile.userName
            self.registeredAt = userProfile.registeredAt
            self.lastActiveAt = userProfile.lastActiveAt
            self.following = userProfile.following
            self.followedBy = userProfile.followedBy
            self.image = userProfile.image
            self.description = userProfile.description
        }
        
        fileprivate func toUserProfile() -> UserProfile {
            return UserProfile(
                id: id,
                email: email,
                realName: realName,
                userName: userName,
                registeredAt: registeredAt,
                lastActiveAt: lastActiveAt,
                following: following,
                followedBy: followedBy,
                image: image,
                description: description
            )
        }
    }
}
