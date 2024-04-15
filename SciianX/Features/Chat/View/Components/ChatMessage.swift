//
//  ChatMessage.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI

struct ChatMessage: View {
    
    var fromUser: Bool = true
    
    var body: some View {
        
        if fromUser {
            HStack {
                Spacer()
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vehicula finibus pretium. Morbi et dolor viverra, convallis metus at, volutpat ligula. Donec non aliquam mauris. Mauris et dolor et lacus.")
                    .font(.footnote)
                    .frame(maxWidth: 300)
                    .padding(4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 1)
                    }
            }
        } else {
            HStack {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vehicula finibus pretium. Morbi et dolor viverra, convallis metus at, volutpat ligula. Donec non aliquam mauris. Mauris et dolor et lacus.")
                    .font(.footnote)
                    .frame(maxWidth: 300)
                    .padding(4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.red, lineWidth: 1)
                    }
                Spacer()
            }
        }
    }
}

#Preview {
    ChatMessage()
}
