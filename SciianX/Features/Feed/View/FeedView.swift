import SwiftUI

struct FeedView: View {
    
    @EnvironmentObject var feedsViewModel: FeedsViewModel
    
    @State private var showAll = true
    @State private var showCreatePost = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()
                
                ScrollView(showsIndicators: false) {
                    Picker(selection: $showAll.animation(), label: Text("Feed_Filter")) {
                        Text("ShowAll_Key")
                            .tag(true)
                        Text("ShowFollowed_Key")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if showAll {
                        LazyVStack {
                            ForEach(self.feedsViewModel.feeds) { feed in
                                FeedRow(feedViewModel: feed)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        LazyVStack {
                            ForEach(self.feedsViewModel.followedFeeds) { feed in
                                FeedRow(feedViewModel: feed)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .sheet(isPresented: $showCreatePost, content: {
                CreateFeedView()
                    .presentationDetents([.medium, .large])
            })
            .navigationTitle("ConXpressions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.showCreatePost = true
                    }, label: {
                        Image(systemName: "plus.app")
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .leading, endPoint: .trailing))
                    })
                }
            }
        }
    }
}
