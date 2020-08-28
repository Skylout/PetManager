//
//  Validators.swift
//  Messenger
//
//  Created by Леонид on 14.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import Foundation

class Validators {
    static func isFilled (email: String?, name: String?, password: String?, confirmPassword: String?) -> Bool{
        guard let password = password,
            let confirmPassword = confirmPassword,
            let email = email,
            let name = name,
            password != "",
            confirmPassword != "",
            email != "",
            name != ""
            else {
                return false
        }
        return true
    }
    
    static func isFilled (email: String?, name: String?) -> Bool{
        guard let email = email,
            let name = name,
            email != "",
            name != ""
            else {
                return false
        }
        return true
    }
    
    static func isSimpleEmail (_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    static func isSimplePassword (_ password: String) -> Bool {
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        return check(text: password, regEx: passRegEx)
        
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
