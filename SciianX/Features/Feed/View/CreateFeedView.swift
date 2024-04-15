import SwiftUI
import PhotosUI

struct CreateFeedView: View {
    
    @EnvironmentObject private var feedsViewModel: FeedsViewModel
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    @State private var post = ""
    @State private var imageItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack(alignment: .top) {
                    ProfilePictureSmall(self.authenticationViewModel.user)
                    
                    VStack(alignment: .leading) {
                        Text(self.authenticationViewModel.user?.userName ?? "")
                            .fontWeight(.semibold)
                        
                        TextField("Write your thoughts", text: $post, axis: .vertical)
                            .fontWeight(.thin)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !post.isEmpty || !images.isEmpty {
                        Button(action: {
                            self.post = ""
                            self.images.removeAll()
                        }, label: {
                            Text("X")
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                                .font(.system(size: 20))
                        })
                    }
                }
                
                if !self.images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack() {
                            ForEach(self.images, id: \.self) { uiImage in
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 200)
                }
                
                Divider()
                
                PhotosPicker("ImagePicker", selection: $imageItems, maxSelectionCount: 5, matching: .images)
                    .frame(height: 200)
                    .photosPickerStyle(.compact)
                    .photosPickerDisabledCapabilities(.selectionActions)
                
                Text("Add up to 5 images")
                    .font(.footnote)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            .onChange(of: self.imageItems) { newItems in
                self.feedsViewModel.convertImagePicker(newItems) { images in
                    self.images = images
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if let user = self.authenticationViewModel.user {
                            self.feedsViewModel.createFeed(self.post, self.images, withUser: user)
                        }
                        self.dismiss()
                    }, label: {
                        Text("Post")
                    })
                    .disabled(self.post.isEmpty)
                }
            }
        }
    }
}
