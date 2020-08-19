//
//  MUser.swift
//  Messenger
//
//  Created by Леонид on 19.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit

struct MUser: Hashable, Decodable {
    var username: String
    var id: Int
    
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
