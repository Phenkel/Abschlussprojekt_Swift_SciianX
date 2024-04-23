//
//  ChatPreviewRow.swift
//  SciianX
//
//  Created by Philipp Henkel on 19.02.24.
//

import SwiftUI

struct ChatPreviewRow: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @ObservedObject private var chatViewModel: ChatViewModel
    
    private var receipient: UserProfile? {
        self.chatViewModel.users.first { $0.id != self.userViewModel.user?.id }
    }
    
    init(_ chatViewModel: ChatViewModel) {
        self._chatViewModel = ObservedObject(wrappedValue: chatViewModel)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ProfilePictureSmall(self.receipient)
                
                VStack(alignment: .leading) {
                    Text(self.receipient?.realName ?? "Error - no receipient found")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text(self.chatViewModel.messages.last?.text ?? "Error - no message found")
                        .font(.footnote)
                        .fontWeight(.thin)
                }
                
                Spacer()
                
                Text(self.chatViewModel.lastActiveAtString)
                    .font(.footnote)
                    .fontWeight(.ultraLight)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Divider()
        }
    }
}
