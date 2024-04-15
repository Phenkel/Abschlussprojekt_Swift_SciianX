//
//  FirebaseManager.swift
//  SciianX
//
//  Created by Philipp Henkel on 05.03.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    
    let auth = Auth.auth()
    let firestore = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    static let shared = FirebaseManager()
    
    private init() {}
}
