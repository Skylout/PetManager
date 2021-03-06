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
import GoogleSignIn

class AuthServices {
    
    static let shared = AuthServices()
    private let auth = Auth.auth()
    
    func login (email: String?, password: String?, completion: @escaping (Result<User, Error>)->Void) {
        
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func googleLogin (user: GIDGoogleUser, error: Error!, completion: @escaping (Result<User, Error>)->Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func register(email: String?, name: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User,Error>)->Void){
        
        guard Validators.isFilled(email: email, name: name, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard Validators.isSimplePassword(password!) else {
            completion(.failure(AuthError.invalidPassword))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
