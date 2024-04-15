//
//  ProfileView.swift
//  SciianX
//
//  Created by Philipp Henkel on 11.01.24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject private var feedsViewModel: FeedsViewModel
    
    @State private var postsFilter: ProfileViewFilter = .xpression
    private var user: UserProfile?
    private var isOwnProfile: Bool {
        return self.userViewModel.checkSameUser(self.user)
    }
    
    init(_ user: UserProfile?) {
        self.user = user
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(self.user?.realName ?? "Error - No Real Name")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(self.user?.userName ?? "Error - No User Name")
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            AsyncImage(
                                url: URL(string: self.user?.image ?? ""),
                                content: { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipShape(Circle())
                                        .overlay(content: {
                                            Circle()
                                                .stroke(lineWidth: 3.0)
                                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                                        })
                                },
                                placeholder: {
                                    Image(systemName: "person.fill.questionmark")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipShape(Circle())
                                        .overlay(content: {
                                            Circle()
                                                .stroke(lineWidth: 3.0)
                                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                                        })
                                }
                            )
                        }
                        Text(self.user?.description ?? "Error - No Description")
                            .font(.footnote)
                        
                        Text((self.user?.followedBy.count.description ?? "Error - No Follower Count") + " Followers")
                            .font(.footnote)
                            .fontWeight(.thin)
                        
                        if isOwnProfile {
                            HStack {
                                SmallButton(
                                    label: "Settings_Key",
                                    color: .red,
                                    action: {
                                        // MARK: TO SETTINGS
                                    }
                                )
                                
                                Spacer()
                                
                                Text("X")
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                                    .font(.system(size: 40))
                                
                                Spacer()
                                
                                NavigationLink(
                                    destination: EditProfileView(),
                                    label: {
                                        Text("Edit_Key")
                                            .foregroundStyle(.blue)
                                            .fontWeight(.semibold)
                                            .frame(width: 100, height: 40)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.blue, lineWidth: 1)
                                            }
                                    }
                                )
                            }
                        } else {
                            if let ownUser = self.userViewModel.user, let user {
                                HStack(alignment: .center) {
                                    BigButton(
                                        label: !ownUser.following.contains(user.id) ? "Follow" : "Unfollow",
                                        color: !ownUser.following.contains(user.id) ? .blue : .red,
                                        action: {
                                            self.userViewModel.followUser(user: user)
                                        }
                                    )
                                }
                                .frame(maxWidth: .infinity)
                                
//                                if let user {
//                                    if !(self.userViewModel.user?.following.contains(user.id) ?? false) {
//                                        BigButton(
//                                            label: "Follow",
//                                            color: .blue,
//                                            action: {
//                                                self.userViewModel.followUser(user: user)
//                                            }
//                                        )
//                                    } else {
//                                        BigButton(
//                                            label: "Unfollow",
//                                            color: .red,
//                                            action: {
//                                                self.userViewModel.followUser(user: user)
//                                            }
//                                        )
//                                    }
//                                }
                            }
                        }
                        
                        Picker(selection: $postsFilter.animation(), label: Text("Profile_Filter")) {
                            ForEach(ProfileViewFilter.allCases) { filter in
                                Text(filter.title).tag(filter)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        if postsFilter == .xpression {
                            LazyVStack {
                                if !isOwnProfile {
                                    if let id = self.user?.id {
                                        ForEach(self.feedsViewModel.getUserPosts(withUserId: id)) { feed in
                                            FeedRow(feedViewModel: feed)
                                        }
                                    }
                                } else {
                                    ForEach(self.feedsViewModel.ownFeeds) { feed in
                                        FeedRow(feedViewModel: feed)
                                    }
                                }
                            }
                        } else if postsFilter == .xchange {
                            LazyVStack {
                                if !isOwnProfile {
                                    if let id = self.user?.id {
                                        ForEach(self.feedsViewModel.getUserXtivity(withUserId: id)) { feed in
                                            FeedRow(feedViewModel: feed)
                                        }
                                    }
                                } else {
                                    ForEach(self.feedsViewModel.usedFeeds) { feed in
                                        FeedRow(feedViewModel: feed)
                                    }
                                }
                            }
                        } else if postsFilter == .xtacts {
                            VStack {
                                LazyVStack {
                                    if !isOwnProfile {
                                        if let id = self.user?.id {
                                            ForEach(self.authenticationViewModel.getUserContacts(withUserId: id)) { user in
                                                ProfilePreviewRow(user)
                                            }
                                        }
                                    } else {
                                        if let id = self.user?.id {
                                            ForEach(self.authenticationViewModel.getUserContacts(withUserId: id)) { user in
                                                ProfilePreviewRow(user)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("ConXdentity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
