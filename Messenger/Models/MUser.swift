//
//  MUser.swift
//  Messenger
//
//  Created by Леонид on 19.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var id: String
    
    init (username: String, email: String, id: String) {
        self.username = username
        self.email = email
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let id = data["uid"] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.id = id
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let id = data["uid"] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.id = id
    }
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["username":username]
        rep["email"] = email
        rep["uid"] = id
        return rep
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool{
        return lhs.id == rhs.id
    }
    
    func contains (filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return username.lowercased().contains(lowercasedFilter)
    }
}
