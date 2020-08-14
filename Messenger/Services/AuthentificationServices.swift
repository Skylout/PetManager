//
//  AuthentificationServices.swift
//  Messenger
//
//  Created by Леонид on 14.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthServices {
    
    private let auth = Auth.auth()
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User,Error>)->Void){
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
