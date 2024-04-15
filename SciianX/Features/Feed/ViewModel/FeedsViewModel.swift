//
//  FeedsViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 12.03.24.
//

import Foundation
import SwiftUI
import PhotosUI

class FeedsViewModel: ObservableObject {
    
    @Published private(set) var feeds: [FeedViewModel] = []
    @Published private(set) var followedFeeds: [FeedViewModel] = []
    @Published private(set) var ownFeeds: [FeedViewModel] = []
    @Published private(set) var usedFeeds: [FeedViewModel] = []
    
    private var user: UserProfile?
    private var allUsers: [UserProfile]
    private let feedRepository = FirebaseFeedRepository.shared
    
    init(_ user: UserProfile?, allUsers: [UserProfile]) {
        self.user = user
        self.allUsers = allUsers
        self.fetchAllFeeds()
    }
    
    func createFeed(_ text: String, _ images: [UIImage], withUser user: UserProfile) {
        let imageData = images.compactMap {
            $0.jpegData(compressionQuality: 0.8)
        }
        
        Task {
            await feedRepository.createFeed(text, imageData, withUser: user)
        }
    }
    
    func convertImagePicker(_ data: [PhotosPickerItem], completion: @escaping ([UIImage]) -> Void) {
        Task {
            var loadedImages: [UIImage] = []
            
            for item in data {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        loadedImages.append(uiImage)
                    }
                }
            }
            
            completion(loadedImages)
        }
    }
    
    func updateAllUsers(_ user: UserProfile, _ allUsers: [UserProfile]) {
        self.user = user
        self.allUsers = allUsers
        self.fetchAllFeeds()
    }
    
    func getUserXtivity(withUserId: String) -> [FeedViewModel] {
        return self.feeds.filter { $0.activeUsers.contains { $0.id == withUserId } }.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    func getUserPosts(withUserId: String) -> [FeedViewModel] {
        return self.feeds.filter { $0.creator?.id == withUserId }
    }
    
    private func fetchAllFeeds() {
        feedRepository.fetchAllFeeds() { result in
            switch result {
            case .success(let allFeeds):
                
                let oldFeeds = self.feeds
                
                self.feeds = allFeeds.compactMap { feed in
                    if let user = self.allUsers.first(where: { $0.id == feed.creator }) {
                        if let oldFeed = oldFeeds.first(where: { $0.id == feed.id }) {
                            if let translatedText = oldFeed.translatedText, !oldFeed.richPreviews.isEmpty {
                                return FeedViewModel(feed, withUser: user, translatedText: translatedText, richPreviews: oldFeed.richPreviews, allUsers: self.allUsers)
                            } else if let translatedText = oldFeed.translatedText {
                                return FeedViewModel(feed, withUser: user, translatedText: translatedText, allUsers: self.allUsers)
                            } else if !oldFeed.richPreviews.isEmpty {
                                return FeedViewModel(feed, withUser: user, richPreviews: oldFeed.richPreviews, allUsers: self.allUsers)
                            } else {
                                return FeedViewModel(feed, withUser: user, allUsers: self.allUsers)
                            }
                        } else {
                            return FeedViewModel(feed, withUser: user, allUsers: self.allUsers)
                        }
                    } else {
                        return nil
                    }
                }
                self.feeds.sort(by: { $0.createdAt > $1.createdAt })
                
                if let user = self.user {
                    self.followedFeeds = self.feeds.filter { user.following.contains($0.creator?.id ?? "") }
                    self.ownFeeds = self.feeds.filter { $0.creator == user }
                    self.usedFeeds = self.feeds.filter { $0.activeUsers.contains(user) }
                    self.usedFeeds.sort(by: { $0.updatedAt > $1.updatedAt })
                }
                
            case .failure(let error):
                print("Failed fetching feeds: \(error)")
            }
        }
    }
}
