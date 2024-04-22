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
                    if let text = message.text {
                        Text(text)
                            .font(.footnote)
                            .frame(maxWidth: 300)
                    }
                    if let image = message.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(maxWidth: 300)
                            .scaledToFit()
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
                    if let text = message.text {
                        Text(text)
                            .font(.footnote)
                            .frame(maxWidth: 300)
                    }
                    if let image = message.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(maxWidth: 300)
                            .scaledToFit()
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
