//
//  ViewController.swift
//  FirebaseFetchProvidersForEmail
//
//  Created by David Thorn on 04.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
        Auth.auth().fetchSignInMethods(forEmail: EMAIL) { (providers, error) in
            
            guard error == nil else {
                
                let errorType = AuthErrorCode.init(rawValue: error!._code)!
                switch errorType {
                case .invalidEmail:
                    print("invalid email address provider")
                default:
                    fatalError("Do not know what the error is!")
                }
                
                return
                
            }
            
            guard let signinMethods = providers else {
                fatalError("no sign methods are available")
            }
            
            print(EmailPasswordAuthSignInMethod)
            print(signinMethods)
            
            
        }
        
    }

}

