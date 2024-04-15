//
//  BackgroundImage.swift
//  SciianX
//
//  Created by Philipp Henkel on 27.02.24.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image(.background)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .frame(minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .opacity(0.3)
    }
}

#Preview {
    BackgroundImage()
}
