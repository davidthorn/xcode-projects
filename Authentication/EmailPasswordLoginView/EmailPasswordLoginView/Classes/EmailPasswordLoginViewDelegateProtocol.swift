//
//  EmailPasswordLoginViewDelegateProtocol.swift
//  EmailPasswordLoginView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public protocol EmailPasswordLoginViewDelegateProtocol {
    
    func authenticate(email: String , password: String , completion: @escaping ( _ error: EmailLoginError? ) -> Void)
    
    /// Should only be called once the user has been authenticated and the authentication method has been called
    func shouldContinue(controller: EmailPasswordLoginViewController)
    
}
