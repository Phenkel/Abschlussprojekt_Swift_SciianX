//
//  FeedRepository.swift
//  SciianX
//
//  Created by Philipp Henkel on 14.03.24.
//

import Foundation

protocol FeedRepository {
    
    func createFeed(_ text: String, withUser user: UserProfile)
    
    func likeFeed(withUser user: UserProfile, feed: Feed)
    
    func createComment(_ text: String, withUser user: UserProfile, feed: Feed)
    
    func fetchAllFeeds(completion: @escaping (Result<[Feed], FirebaseError>) -> Void)
}
