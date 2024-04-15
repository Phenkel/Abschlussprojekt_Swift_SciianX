//
//  BigButton.swift
//  SciianX
//
//  Created by Philipp Henkel on 26.02.24.
//

import SwiftUI

struct BigButton: View {
    
    var label: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action, label: {
            HStack {
                Text(self.label)
                    .foregroundStyle(self.color)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(self.color, lineWidth: 1)
                    }
            }
        })
    }
}

#Preview {
    BigButton(
        label: "Delete",
        color: .red,
        action: {}
    )
}
