//
//  FirestoreService.swift
//  Messenger
//
//  Created by Леонид on 19.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func  saveProfileWith (id: String, email: String, username: String, completion: @escaping (Result))  {
        <#function body#>
    }
}
