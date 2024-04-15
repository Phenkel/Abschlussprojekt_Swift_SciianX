//
//  Comment.swift
//  SciianX
//
//  Created by Philipp Henkel on 12.03.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Codable {
    @DocumentID var id: String?
    
    let creator: String
    let text: String
    let createdAt: Date
}
