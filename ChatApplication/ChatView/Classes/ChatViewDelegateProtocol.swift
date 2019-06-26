//
//  ChatViewDelegateProtocol.swift
//  ChatView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public protocol ChatViewDelegateProtocol {
    
    // Should be called by the view when a new message should be sent
    func sendMessage(text: String , completion: @escaping ( _ error: ChatViewError? ) -> Void)
    
}
