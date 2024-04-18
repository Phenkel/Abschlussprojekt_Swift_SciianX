//
//  SingleChatView.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI

struct SingleChatView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @ObservedObject private var chatViewModel: ChatViewModel
    
    @State private var message: String = ""
    
    private var receipient: UserProfile? {
        self.chatViewModel.users.first { $0.id != self.userViewModel.user?.id }
    }
    
    init(_ chatViewModel: ChatViewModel) {
        self._chatViewModel = ObservedObject(wrappedValue: chatViewModel)
    }
    
    var body: some View {
        ZStack {
            BackgroundImage()
            
            VStack {
                if let receipient {
                    ProfilePreviewRow(receipient)
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(self.chatViewModel.messages) { message in
                            ChatMessageRow(message, fromUser: receipient?.id != message.sender)
                        }
                    }
                }
                .defaultScrollAnchor(.bottom)
                
                HStack {
                    TextField("NewMessage_Key", text: $message, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: {
                        if !self.message.isEmpty, let userId = self.userViewModel.user?.id {
                            self.chatViewModel.sendMessage(self.message, userId: userId)
                            self.message = ""
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill")
                    })
                }
            }
            .padding()
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
