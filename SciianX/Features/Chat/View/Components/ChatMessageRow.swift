//
//  ChatMessage.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI

struct ChatMessageRow: View {
    
    private var message: ChatMessage
    private var fromUser: Bool
    
    init(_ message: ChatMessage, fromUser: Bool) {
        self.message = message
        self.fromUser = fromUser
    }
    
    var body: some View {
        
        if fromUser {
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(self.message.text)
                        .font(.footnote)
                        .frame(maxWidth: 300)
                        .padding(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 1)
                        }
                }
            }
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(self.message.text)
                        .font(.footnote)
                        .frame(maxWidth: 300)
                        .padding(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 1)
                        }
                    
                    Text(self.message.createdAt.description)
                        .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
            }
        }
    }
}
