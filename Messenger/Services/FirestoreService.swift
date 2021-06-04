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
    
    var currentUser: MUser!
    
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
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(AuthError.cannotGetUser))
            }
        }
    }
    
    
    func searchUser (searchingUser: String, completion: @escaping (Result<MUser, Error>) -> Void) {
        usersRef.whereField("username", isEqualTo: searchingUser).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let resultUser = querySnapshot?.documents.first else {
                completion(.failure(AuthError.cannotGetUser))
                return
            }
            let muser = MUser(document: resultUser)!
            completion(.success(muser))
        }
    }
    
    func createChat (reciever: MUser, completion: @escaping (Result<MChat, Error>) -> Void) {
        let recieverRef = db.collection(["users", reciever.id, "activeChats"].joined(separator: "/"))
        let currentUserRef = db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
        
        let messageRef = recieverRef.document(self.currentUser.id).collection("messages")
        let currentUserMessRef = currentUserRef.document(reciever.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: "")
        
        let recieverChat = MChat(username: currentUser.username,
                         lastMessage: nil,
                         id: currentUser.id)
        
        recieverRef.document(currentUser.id).setData(recieverChat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
        }
        
        let currentUserChat = MChat(username: reciever.username, lastMessage: nil, id: reciever.id)
        
        currentUserRef.document(reciever.id).setData(currentUserChat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            currentUserMessRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(currentUserChat))
            }
        }
    }
}
