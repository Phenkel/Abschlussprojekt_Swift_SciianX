//
//  CommentsView.swift
//  SciianX
//
//  Created by Philipp Henkel on 13.03.24.
//

import SwiftUI

struct CommentsView: View {
    
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var comment = ""
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        HStack(alignment: .top) {
                            ProfilePictureSmall(self.authenticationViewModel.user)
                            
                            VStack(alignment: .leading) {
                                Text(self.authenticationViewModel.user?.realName ?? "")
                                    .fontWeight(.semibold)
                                
                                TextField("Write your thoughts", text: $comment, axis: .vertical)
                                    .fontWeight(.thin)
                            }
                            .font(.footnote)
                            
                            Spacer()
                            
                            if !comment.isEmpty {
                                Button(action: {
                                    self.comment = ""
                                }, label: {
                                    Text("X")
                                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                                        .font(.system(size: 20))
                                })
                            }
                        }
                        
                        Divider()
                        
                        LazyVStack {
                            ForEach(self.feedViewModel.comments) { comment in
                                CommentRow(commentViewModel: comment)
                            }
                        }
                    }
                    .padding()
                    .navigationTitle("Comments")
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
                                self.feedViewModel.createComment(comment)
                                self.dismiss()
                            }, label: {
                                Text("Post")
                            })
                            .disabled(self.comment.isEmpty)
                        }
                    }
                }
            }
        }
    }
}
