//
//  ChatMessage.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI

struct ChatMessageRow: View {
    
    @ObservedObject private var message: MessageViewModel
    private var fromUser: Bool
    
    init(_ message: MessageViewModel, fromUser: Bool) {
        self.message = message
        self.fromUser = fromUser
    }
    
    var body: some View {
        
        if fromUser {
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    if let image = message.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    if let text = message.text {
                        Text(text)
                            .font(.footnote)
                            .frame(maxWidth: 300)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text(message.createdAtString)
                            .font(.footnote)
                            .fontWeight(.ultraLight)
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 1)
                }
            }
        } else {
            HStack {
                VStack(alignment: .leading) {
                    if let image = message.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    if let text = message.text {
                        Text(text)
                            .font(.footnote)
                            .frame(maxWidth: 300)
                    }
                    
                    HStack {
                        Text(message.createdAtString)
                            .font(.footnote)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 1)
                }
                Spacer()
            }
        }
    }
}
