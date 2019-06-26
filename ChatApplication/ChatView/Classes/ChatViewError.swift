//
//  ChatViewError.swift
//  ChatView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public enum ChatViewError: String {
    case couldNotSend = "The message could not be sent"
    case networkError = "Please check your internet connection"
    case userNotAuthenticated = "the user is not authenticated"
}
