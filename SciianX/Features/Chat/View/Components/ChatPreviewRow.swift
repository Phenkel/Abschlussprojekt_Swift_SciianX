//
//  ChatPreviewRow.swift
//  SciianX
//
//  Created by Philipp Henkel on 19.02.24.
//

import SwiftUI

struct ChatPreviewRow: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                //ProfilePictureSmall()
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in erat sit amet enim dapibus tempus nec quis quam. Etiam.")
                        .font(.footnote)
                        .fontWeight(.thin)
                    
                    Text("Time")
                        .font(.footnote)
                        .fontWeight(.ultraLight)
                }
                
                Spacer()
                
                Text("New")
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Divider()
        }
    }
}

#Preview {
    ChatPreviewRow()
}
