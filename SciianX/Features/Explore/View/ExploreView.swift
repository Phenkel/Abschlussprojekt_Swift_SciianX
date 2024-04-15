//
//  ExploreView.swift
//  SciianX
//
//  Created by Philipp Henkel on 11.01.24.
//

import SwiftUI

struct ExploreView: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var search = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if self.search.isEmpty {
                            ForEach(self.authenticationViewModel.allUsers) { user in
                                ProfilePreviewRow(user)
                            }
                        } else {
                            ForEach(self.authenticationViewModel.allUsers.filter {
                                $0.userName.lowercased().contains(self.search.lowercased()) || $0.realName.lowercased().contains(self.search.lowercased())
                            }) { user in
                                ProfilePreviewRow(user)
                            }
                        }
                    }
                }
                .navigationTitle("ConXplore")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $search, prompt: "Search_Key")
            }
        }
    }
}
