//
//  AppDelegate.swift
//  FirebaseValidateUserLoggedIn
//
//  Created by David Thorn on 04.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var activeController: UIViewController!

    var navigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            print("auth state did change \(user)")
            switch user {
            case nil:
                guard self.activeController! is SecretContentViewController else { return }
                let publicController = sb.instantiateViewController(withIdentifier: "Public") as! PublicContentViewController
                self.navigationController.setViewControllers([publicController], animated: false)
                self.navigationController.popToViewController(publicController, animated: true)
                self.activeController = publicController
            default:
                /// secret view should be shown
                guard self.activeController! is PublicContentViewController else { return }
                let secretViewController = sb.instantiateViewController(withIdentifier: "Secret") as! SecretContentViewController
                self.navigationController.setViewControllers([secretViewController], animated: false)
                self.navigationController.popToViewController(secretViewController, animated: true)
                self.activeController = secretViewController
            }
            
        }
        
        
        let publicController = sb.instantiateViewController(withIdentifier: "Public") as! PublicContentViewController
        let secretController = sb.instantiateViewController(withIdentifier: "Secret") as! SecretContentViewController
        
        activeController = publicController
        
        switch Auth.auth().currentUser != nil {
        case true:
            activeController = secretController
            print("user was logged on start up")
        default: break
        }
        
        navigationController = UINavigationController.init(rootViewController: activeController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    
}

