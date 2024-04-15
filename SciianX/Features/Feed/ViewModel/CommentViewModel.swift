//
//  CommentViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 13.03.24.
//

import Foundation

class CommentViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var creator: UserProfile?
    @Published private(set) var text: String
    @Published private(set) var translatedText: String?
    @Published private(set) var createdAt: Date
    @Published private(set) var createdAtString: String
    
    let id: String?
    
    private let translationRepository = TranslationRepository.shared
    
    init(_ comment: Comment, _ user: UserProfile?) {
        self.creator = user
        self.text = comment.text
        self.createdAt = comment.createdAt
        self.createdAtString = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy HH:mm"
            return formatter.string(from: comment.createdAt)
        }()
        self.id = comment.id
    }
    
    @MainActor
    func translateText() {
        Task {
            do {
                let translation = try await translationRepository.translateText(self.text)
                
                self.translatedText = translation.data.translatedText
            } catch {
                print("Failed translating text: \(error)")
            }
        }
    }
    
    func asComment() -> Comment {
        return Comment(
            id: self.id,
            creator: self.creator?.id ?? "",
            text: self.text,
            createdAt: self.createdAt
        )
    }
}
