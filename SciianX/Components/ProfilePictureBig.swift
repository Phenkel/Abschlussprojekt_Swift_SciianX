//
//  ProfilePictureBig.swift
//  SciianX
//
//  Created by Philipp Henkel on 19.02.24.
//

import SwiftUI

struct ProfilePictureBig: View {
    
    @Binding private var image: UIImage?
    
    private let user: UserProfile?
    
    init(_ user: UserProfile?, image: Binding<UIImage?>) {
        self.user = user
        self._image = image
    }
    
    var body: some View {
        if let image = self.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipShape(Circle())
                .overlay(content: {
                    Circle()
                        .stroke(lineWidth: 3.0)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                })
        } else {
            AsyncImage(
                url: URL(string: self.user?.image ?? ""),
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
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
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(Circle())
                        .overlay(content: {
                            Circle()
                                .stroke(lineWidth: 3.0)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                        })
                }
            )
        }
    }
}
