//
//  SingleChatView.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI
import PhotosUI

struct SingleChatView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @ObservedObject private var chatViewModel: ChatViewModel
    
    @State private var message: String = ""
    @State private var imageItem: PhotosPickerItem?
    @State private var image: UIImage?
        
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
                
                HStack(alignment: .bottom) {
                    TextField("NewMessage_Key", text: $message, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    
                    if let image {
                        Button(action: {
                            self.imageItem = nil
                        }, label: {
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .scaledToFill()
                                
                                Image(systemName: "xmark.bin.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                        })
                    } else {
                        PhotosPicker(selection: $imageItem, matching: .images, label: {
                            Image(systemName: "paperclip")
                                .resizable()
                                .frame(width: 32, height: 32)
                        })
                    }
                    
                    Button(action: {
                        if !self.message.isEmpty, let userId = self.userViewModel.user?.id {
                            self.chatViewModel.sendMessage(self.message, image: self.image, userId: userId)
                            self.message = ""
                            self.imageItem = nil
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                    })
                }
            }
            .padding()
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: self.imageItem) { item in
            self.chatViewModel.convertImagePicker(item) { image in
                self.image = image
            }
        }
    }
}
