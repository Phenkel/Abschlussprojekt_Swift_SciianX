//
//  SingleChatView.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI

struct SingleChatView: View {
    
    @State private var message: String = ""
    
    var body: some View {
        ZStack {
            BackgroundImage()
            
            VStack {
                //ProfilePreviewRow()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(0...25, id: \.self) { post in
                            ChatMessage(fromUser: Bool.random())
                        }
                    }
                }
                .defaultScrollAnchor(.bottom)
                
                TextField("NewMessage_Key", text: $message, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Text("Translated Texts")
                        .font(.caption2)
                })
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    SingleChatView()
}
