//
//  ProfilePictureSmallView.swift
//  SciianX
//
//  Created by Philipp Henkel on 12.01.24.
//

import SwiftUI

struct ProfilePictureSmall: View {
    
    private let user: UserProfile?
    
    init(_ user: UserProfile?) {
        self.user = user
    }
    
    var body: some View {
        NavigationLink(destination: {
            ProfileView(self.user)
        }, label: {
            AsyncImage(
                url: URL(string: self.user?.image ?? ""),
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(content: {
                            Circle()
                                .stroke(lineWidth: 3.0)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                        })
                },
                placeholder: {
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(content: {
                            Circle()
                                .stroke(lineWidth: 3.0)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                        })
                }
            )
        })
    }
}
