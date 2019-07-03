//
//  ViewController.swift
//  FirebaseAuthExample
//
//  Created by David Thorn on 03.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //try! Auth.auth().signOut()
        
        guard let user = Auth.auth().currentUser else {
            return self.signin(auth: Auth.auth())
        }
        
        user.reload { (error) in
            switch user.isEmailVerified {
            case true:
                print("users email is verified")
            case false:
                
                user.sendEmailVerification { (error) in
                    
                    guard let error = error else {
                        return print("user email verification sent")
                    }
                    
                    self.handleError(error: error)
                }
                
                print("verify it now")
            }
        }
        
        
        
//        user.delete { (error) in
//            guard let error = error else {
//                return print("user was deleted")
//            }
//            self.handleError(error: error)
//        }
        
        print("Logged in user: \(user.email)")
    }
    
    func handleError(error: Error) {
        
        /// the user is not registered
        /// user not found
        
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .wrongPassword:
            print("wrongPassword")
        case .invalidEmail:
            print("invalidEmail")
        case .operationNotAllowed:
            print("operationNotAllowed")
        case .userDisabled:
            print("userDisabled")
        case .userNotFound:
            print("userNotFound")
            self.register(auth: Auth.auth())
        case .tooManyRequests:
            print("tooManyRequests, oooops")
        default: fatalError("error not supported here")
        }
        
    }
    
    func signin(auth: Auth) {
        
        auth.signIn(withEmail: EMAIL, password: PASSWORD) { (result, error) in
            
            guard error == nil else {
                return self.handleError(error: error!)
            }
            
            guard let user = result?.user else{
                fatalError("Not user do not know what went wrong")
            }
            
            print("Signed in user: \(user.email)")
            
        }
        
    }
    
    func register(auth: Auth) {
        
        auth.createUser(withEmail: EMAIL, password: PASSWORD) { (result, error) in
            
            guard error == nil else {
                return self.handleError(error: error!)
            }
            
            guard let user = result?.user else {
                fatalError("Do not know why this would happen")
            }
            
            print("registered user: \(user.email)")
            
        }
        
    }
   
}

