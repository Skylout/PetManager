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
    
    func saveProfileWith (id: String, email: String, username: String, completion: @escaping (Result<MUser, Error>) -> Void)  {
        
        guard Validators.isFilled(email: email, name: username) else {
            completion(.failure(AuthError.notFilled)) //В связи с тем, что в той реализации, которую я видел, этот процесс был вынесен на отдельный экран - то и ошибки у него были отдельные. В моей реализации оно делается на одном экране и использует один лог ошибок.
            return
        }
        
        let muser = MUser(username: username,
                          email: email,
                          id: id)
        self.usersRef.document(muser.id).setData(muser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(muser))
            }
        }
        
    }
    
    func getUserData (user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docReference = usersRef.document(user.uid)
        docReference.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(AuthError.cannorUnwrapUser))
                    return
                }
                completion(.success(muser))
            } else {
                completion(.failure(AuthError.cannotGetUser))
            }
        }
    }
}
