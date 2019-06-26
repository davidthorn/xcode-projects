//
//  AppDelegate.swift
//  AuthenticationApplication
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import EmailPasswordLoginView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let vc = EmailPasswordLoginViewController.instance(delegate: self , defaultEmailString: "david.thorn")!
        self.window?.rootViewController = vc.inNavigationController()
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

extension AppDelegate: EmailPasswordLoginViewDelegateProtocol {
    
    func authenticate(email: String, password: String, completion: @escaping (EmailLoginError?) -> Void) {
        
        switch email {
        case "david.thorn":
            completion(.wrongPassword)
        default:
            completion(nil)
        }
        
    }
    
    func shouldContinue(controller: EmailPasswordLoginViewController) {
        print("all good here")
    }
    
}
