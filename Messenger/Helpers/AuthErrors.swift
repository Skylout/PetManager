//
//  AuthErrors.swift
//  Messenger
//
//  Created by Леонид on 18.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case invalidPassword
    case passwordsNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError{
    var errorDescription: String? {
        switch self {

        case .notFilled:
            return NSLocalizedString("Required field are empty", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email", comment: "")
        case .invalidPassword:
            return NSLocalizedString("Invalid password", comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString("Passwords are not equal", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}
