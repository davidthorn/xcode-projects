//
//  EmailLoginError.swift
//  EmailPasswordLoginView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public enum EmailLoginError: String {
    
    case userNotFound = "User not found"
    
    case invalidEmail = "The email provided is invalid"
    
    case disabledUser = "The user with this email has been disabled"
    
    case wrongPassword = "Either the password or email address provided are incorrect"
    
}
