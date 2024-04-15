//
//  FeedViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 12.03.24.
//

import Foundation

class FeedViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var creator: UserProfile?
    @Published private(set) var text: String
    @Published private(set) var translatedText: String?
    @Published private(set) var likes: [UserProfile] = []
    @Published private(set) var comments: [CommentViewModel] = []
    @Published private(set) var createdAt: Date
    @Published private(set) var createdAtString: String
    @Published private(set) var updatedAt: Date
    @Published private(set) var activeUsers: [UserProfile] = []
    @Published private(set) var images: [String]
    @Published private(set) var richPreviews: [RichPreviewViewModel] = []
    
    let id: String?
    
    private let user: UserProfile
    private let originalText: String
    private let translationRepository = TranslationRepository.shared
    private let feedRepository = FirebaseFeedRepository.shared
    
    init(_ feed: Feed, withUser user: UserProfile, allUsers: [UserProfile], fetchRichPreview: Bool = true) {
        self.text = feed.text
        self.createdAt = feed.createdAt
        self.createdAtString = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy HH:mm"
            return formatter.string(from: feed.createdAt)
        }()
        self.updatedAt = feed.updatedAt
        self.images = feed.images
        
        self.id = feed.id
        self.user = user
        self.originalText = feed.text
        
        let (text, urlSets) = filterAndReplaceURs(self.text)
        self.text = text
        if fetchRichPreview {
            self.urlSetsToRichPreviews(urlSet: urlSets)
        }
        
        self.comments = feed.comments.compactMap { CommentViewModel($0, self.fetchCommentCreatorProfile($0.creator, allUsers)) }
        
        self.fetchCreatorProfile(userId: user.id, allUsers)
        self.fetchLikesProfiles(userIds: feed.likes, allUsers)
        self.fetchActiveProfiles(userIds: feed.activeUsers, allUsers)
    }
    
    convenience init(_ feed: Feed, withUser user: UserProfile, translatedText: String?, richPreviews: [RichPreviewViewModel], allUsers: [UserProfile]) {
        self.init(feed, withUser: user, allUsers: allUsers, fetchRichPreview: false)
        
        self.translatedText = translatedText
        self.richPreviews = richPreviews
    }
    
    convenience init(_ feed: Feed, withUser user: UserProfile, translatedText: String?, allUsers: [UserProfile]) {
        self.init(feed, withUser: user, allUsers: allUsers)
        
        self.translatedText = translatedText
    }
    
    convenience init(_ feed: Feed, withUser user: UserProfile, richPreviews: [RichPreviewViewModel], allUsers: [UserProfile]) {
        self.init(feed, withUser: user, allUsers: allUsers, fetchRichPreview: false)
        
        self.richPreviews = richPreviews
    }
    
    @MainActor
    func translateText() {
        Task {
            do {
                let translation = try await translationRepository.translateText(self.text)
                
                let (text, _) = self.filterAndReplaceURs(translation.data.translatedText)
                
                self.translatedText = text
            } catch {
                print("Failed translating text: \(error)")
            }
        }
    }
    
    func likeFeed() {
        feedRepository.likeFeed(withUser: user, feed: self.asFeed())
    }
    
    func createComment(_ text: String) {
        self.feedRepository.createComment(text, withUser: user, feed: self.asFeed())
    }
    
    func fetchCreatorProfile(userId id: String, _ users: [UserProfile]) {
        let user = users.filter { $0.id == id }.first
        
        self.creator = user
    }
    
    func fetchLikesProfiles(userIds ids: [String], _ users: [UserProfile]) {
        let users = users.filter { ids.contains($0.id) }
        
        self.likes = users
    }
    
    func fetchActiveProfiles(userIds ids: [String], _ users: [UserProfile]) {
        let users = users.filter { ids.contains($0.id) }
        
        self.activeUsers = users
    }
    
    private func asFeed() -> Feed {
        return Feed(
            id: self.id,
            creator: self.creator?.id ?? "",
            text: self.originalText,
            likes: self.likes.compactMap {
                $0.id
            },
            comments: self.comments.compactMap {
                $0.asComment()
            },
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            activeUsers: self.activeUsers.compactMap {
                $0.id
            },
            images: self.images
        )
    }
    
    private func filterAndReplaceURs(_ text: String) -> (String, [(number: String, url: URL)]) {
        // Create a regular expression to match URLs.
        // The pattern includes:
        // - https?://: Matches the "http://" or "https://" protocol prefix.
        // - www.: Matches the "www." subdomain prefix.
        // - [-a-zA-Z0-9+&@#/%?=~_|!:,.;]*: Matches any combination of letters, numbers, symbols, and punctuation characters.
        // - [-a-zA-Z0-9+&@#/%=~_|]: Matches any combination of letters, numbers, symbols, and punctuation characters at the end of the URL.
        let regex = try! NSRegularExpression(pattern: "(https?://|www\\.)[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]")
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
        
        var replacedText = text
        var urls: [(String, URL)] = []
        var counter = 1
        
        for match in matches {
            let urlString = (text as NSString).substring(with: match.range)
            if let url = URL(string: urlString) {
                let replacement = "(\(counter))"
                replacedText = replacedText.replacingOccurrences(of: urlString, with: replacement)
                
                urls.append((replacement, url))
                
                counter += 1
            }
        }
        
        return (replacedText, urls)
    }
    
    private func urlSetsToRichPreviews(urlSet: [(number: String, url: URL)]) {
        Task {
            await MainActor.run {
                self.richPreviews = urlSet.compactMap {
                    RichPreviewViewModel($0)
                }
            }
        }
    }
    
    private func fetchCommentCreatorProfile(_ id: String, _ users: [UserProfile]) -> UserProfile? {
        return users.filter { $0.id == id }.first
    }
}
