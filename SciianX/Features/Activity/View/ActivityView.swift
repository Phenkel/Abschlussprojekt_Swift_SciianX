//
//  ActivityView.swift
//  SciianX
//
//  Created by Philipp Henkel on 11.01.24.
//

import SwiftUI

struct ActivityView: View {
    
    @EnvironmentObject var feedsViewModel: FeedsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(self.feedsViewModel.usedFeeds) { feed in
                            FeedRow(feedViewModel: feed)
                        }
                    }
                }
            }
            .navigationTitle("ConXtivity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
