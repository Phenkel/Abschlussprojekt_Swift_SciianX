//
//  ProfilePreviewView.swift
//  SciianX
//
//  Created by Philipp Henkel on 12.01.24.
//

import SwiftUI

struct ProfilePreviewRow: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    private let user: UserProfile
    
    init(_ user: UserProfile) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            HStack {
                ProfilePictureSmall(self.user)
                
                VStack(alignment: .leading) {
                    Text(self.user.userName)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text(self.user.realName)
                        .font(.footnote)
                        .fontWeight(.thin)
                }
                
                Spacer()
                
                
                if let ownUser = self.userViewModel.user, ownUser.id != self.user.id {
                    SmallButton(
                        label: !(self.user.followedBy.contains(ownUser.id)) ? "Follow" : "Unfollow",
                        color: !(self.user.followedBy.contains(ownUser.id)) ? .blue : .red,
                        action: {
                            self.userViewModel.followUser(user: self.user)
                        }
                    )
                }
                //                    if let ownUser = self.userViewModel.user {
                //                        if !(ownUser.following.contains(self.user.id)) {
                //                            SmallButton(
                //                                label: "Follow",
                //                                color: .blue,
                //                                action: {
                //                                    self.userViewModel.followUser(user: self.user)
                //                                }
                //                            )
                //                        } else {
                //                            SmallButton(
                //                                label: "Unfollow",
                //                                color: .red,
                //                                action: {
                //                                    self.userViewModel.followUser(user: self.user)
                //                                }
                //                            )
                //                        }
                //                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Divider()
        }
    }
}
