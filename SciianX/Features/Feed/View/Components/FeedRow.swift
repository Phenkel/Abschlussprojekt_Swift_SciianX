import SwiftUI

struct FeedRow: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var chatOverviewViewModel: ChatOverviewViewModel
    @ObservedObject var feedViewModel: FeedViewModel
    
    @State private var showComments = false
    @State private var translationActive: Bool = false
    
    private var textIsTranslated: Bool {
        self.feedViewModel.translatedText != nil
    }
    private var isOwnProfile: Bool {
        self.feedViewModel.creator?.id == self.authenticationViewModel.user?.id
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 16) {
                ProfilePictureSmall(self.feedViewModel.creator)
                
                VStack(spacing: 8) {
                    HStack {
                        if let name = self.feedViewModel.creator?.realName {
                            Text(name)
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        if !isOwnProfile {
                            if let receiverId = self.feedViewModel.creator?.id, let userId = self.authenticationViewModel.user?.id {
                                NavigationLink(destination: {
                                    SingleChatView(self.chatOverviewViewModel.getChat(receiver: receiverId, userId: userId))
                                }, label: {
                                    Image(systemName: "envelope")
                                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .leading, endPoint: .trailing))
                                })
                            }
                        }
                    }
                    Text((!self.translationActive ? self.feedViewModel.text : self.feedViewModel.translatedText) ?? "")
                        .font(.footnote)
                        .fontWeight(.thin)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .bottom, spacing: 16) {
                        VStack {
                            Button(action: {
                                self.feedViewModel.likeFeed()
                            }, label: {
                                Image(systemName: "heart")
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .leading, endPoint: .trailing))
                            })
                            Text(String(self.feedViewModel.likes.count))
                                .font(.footnote)
                                .fontWeight(.ultraLight)
                        }
                        
                        VStack {
                            Button(action: {
                                self.showComments = true
                            }, label: {
                                Image(systemName: "text.bubble")
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                            })
                            Text(String(self.feedViewModel.comments.count))
                                .font(.footnote)
                                .fontWeight(.ultraLight)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                self.translationActive.toggle()
                            }, label: {
                                Text(self.textIsTranslated ? (self.translationActive ? "Show original" : "Translate") : "No Translation")
                            })
                            .disabled(!self.textIsTranslated)
                            
                            Text(self.feedViewModel.createdAtString)
                                .fontWeight(.ultraLight)
                        }
                        .font(.footnote)
                    }
                }
            }
            
            if !self.feedViewModel.images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .center) {
                        ForEach(self.feedViewModel.images, id: \.self) { url in
                            AsyncImage(
                                url: URL(string: url),
                                content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                },
                                placeholder: {
                                    Image(systemName: "network.slash")
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 200)
            }
            
            Divider()
            
            if !self.feedViewModel.richPreviews.isEmpty {
                ForEach(self.feedViewModel.richPreviews) { richLinkPreview in
                    RichLinkPreviewView(richPreviewViewModel: richLinkPreview)
                }
            }
        }
        .sheet(isPresented: $showComments, content: {
            CommentsView()
                .environmentObject(self.feedViewModel)
                .presentationDetents([.medium, .large])
        })
        .onAppear {
            self.feedViewModel.translateText()
        }
        .onChange(of: self.textIsTranslated) {
            if self.textIsTranslated {
                self.translationActive = true
            } else {
                self.translationActive = false
            }
        }
    }
}
