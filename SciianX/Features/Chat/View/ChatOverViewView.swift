//
//  ChatView.swift
//  SciianX
//
//  Created by Philipp Henkel on 11.01.24.
//

import SwiftUI

struct ChatOverViewView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatOverviewViewModel: ChatOverviewViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()
                
                ScrollView(.vertical, showsIndicators: false) {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        ForEach(self.authenticationViewModel.getUserContacts(withUserId: self.userViewModel.user?.id ?? "")) { user in
//                            // MARK: NAVLINK TO CHAT
//                            ProfilePictureSmall(user)
//                        }
//                    }
                    
                    LazyVStack {
                        ForEach(self.chatOverviewViewModel.allChats) { chat in
                            NavigationLink(
                                destination: SingleChatView(chat),
                                label: {
                                    ChatPreviewRow(chat)
                                })
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("ConXversations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
