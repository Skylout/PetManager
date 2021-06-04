//
//  ListenerServices.swift
//  Messenger
//
//  Created by Леонид on 27.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve (users: [MUser],completion: @escaping (Result<[MUser], Error>)->Void) -> ListenerRegistration?{
        var users = users
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let muser = MUser(document: diff.document) else { return }
                switch diff.type {
                    
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.id != self.currentUserID else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    func chatsObserve (chats: [MChat],completion: @escaping (Result<[MChat], Error>)->Void) -> ListenerRegistration? {
        var chats = chats
            let chatsRef = db.collection(["users", currentUserID, "activeChats"].joined(separator: "/"))
            let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    completion(.failure(error!))
                    return
                }
                
                snapshot.documentChanges.forEach { (diff) in
                    guard let chat = MChat(document: diff.document) else { return }
                    switch diff.type {
                    case .added:
                        guard !chats.contains(chat) else { return }
                        chats.append(chat)
                    case .modified:
                        guard let index = chats.firstIndex(of: chat) else { return }
                        chats[index] = chat
                    case .removed:
                        guard let index = chats.firstIndex(of: chat) else { return }
                        chats.remove(at: index)
                    }
                }
                
                completion(.success(chats))
            }
            
            return chatsListener
        }
}
