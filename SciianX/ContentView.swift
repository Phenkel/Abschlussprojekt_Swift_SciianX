import SwiftUI

enum PageSelection: String {
    case feed, explore, chat, activity, profile
}

struct ContentView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var feedsViewModel: FeedsViewModel
    @StateObject var userViewModel: UserViewModel
    
    @State private var selected: PageSelection = .feed
    
    init(_ authenticationViewModel: AuthenticationViewModel) {
        self._feedsViewModel = StateObject(wrappedValue: FeedsViewModel(authenticationViewModel.user, allUsers: authenticationViewModel.allUsers))
        self._userViewModel = StateObject(wrappedValue: UserViewModel(authenticationViewModel.user, authenticationViewModel.allUsers))
    }
    
    var body: some View {
        TabView(selection: $selected) {
            FeedView()
                .tabItem {
                    Image(systemName: selected == .feed ? "house.fill" : "house")
                        .environment(\.symbolVariants, selected == .feed ? .fill : .none)
                    Text("Xpressions")
                }
                .tag(PageSelection.feed)
                .environmentObject(self.userViewModel)
                .environmentObject(self.feedsViewModel)
            
            ExploreView()
                .tabItem {
                    Image(systemName: selected == .explore ? "circle.hexagonpath.fill" : "circle.hexagonpath")
                        .environment(\.symbolVariants, selected == .explore ? .fill : .none)
                    Text("Xplore")
                }
                .tag(PageSelection.explore)
                .environmentObject(self.userViewModel)
                .environmentObject(self.feedsViewModel)
            
            ChatOverViewView()
                .tabItem {
                    Image(systemName: selected == .chat ? "message.fill" : "message")
                        .environment(\.symbolVariants, selected == .chat ? .fill : .none)
                    Text("Xversations")
                }
                .tag(PageSelection.chat)
                .badge(99)
                .environmentObject(self.userViewModel)
                .environmentObject(self.feedsViewModel)
            
            ActivityView()
                .tabItem {
                    Image(systemName: selected == .activity ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selected == .activity ? .fill : .none)
                    Text("Xtivity")
                }
                .tag(PageSelection.activity)
                .environmentObject(self.userViewModel)
                .environmentObject(self.feedsViewModel)
            
            ProfileView(self.authenticationViewModel.user)
                .tabItem {
                    Image(systemName: selected == .profile ? "person.fill" : "person")
                        .environment(\.symbolVariants, selected == .profile ? .fill : .none)
                    Text("Xdentity")
                }
                .tag(PageSelection.profile)
                .environmentObject(self.userViewModel)
                .environmentObject(self.feedsViewModel)
        }
        .onChange(of: self.authenticationViewModel.allUsers) { users in
            if let user = self.authenticationViewModel.user {
                self.feedsViewModel.updateAllUsers(user, users)
            }
        }
        .onChange(of: self.authenticationViewModel.user) { user in
            if let user {
                self.feedsViewModel.updateAllUsers(user, self.authenticationViewModel.allUsers)
                self.userViewModel.updateUser(user)
            }
        }
    }
}
