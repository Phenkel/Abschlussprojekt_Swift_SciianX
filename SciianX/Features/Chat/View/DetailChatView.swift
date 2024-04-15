//
//  DetailChatView.swift
//  SciianX
//
//  Created by Philipp Henkel on 18.03.24.
//

import SwiftUI
import ExyteChat

struct DetailChatView: View {
    
    @State var messages: [Message] = []
    
    var body: some View {        
        ChatView(messages: self.messages) { draft in
            
        }
    }
}

#Preview {
    DetailChatView()
}
