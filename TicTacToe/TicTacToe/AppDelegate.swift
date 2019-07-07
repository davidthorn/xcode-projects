//
//  AppDelegate.swift
//  TicTacToe
//
//  Created by David Thorn on 05.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var navigation: UINavigationController = {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        var activeController: UIViewController!
        switch Auth.auth().currentUser == nil {
        case true:
            activeController = LoginViewController.instance()
        case false:
            activeController = GamesListViewController.instance(user: Auth.auth().currentUser!)
        }
        
        let nav = UINavigationController.init(rootViewController: activeController)
        return nav
    }()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        self.window?.rootViewController = self.navigation
        self.window?.makeKeyAndVisible()
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            
            switch user == nil {
            case true:
                guard !(self.navigation.topViewController is LoginViewController) else { return }
                let vc = LoginViewController.instance()
                self.navigation.setViewControllers([vc], animated: false)
                self.navigation.popToRootViewController(animated: true)
            case false: break
            }
            
        }
        
        // Override point for customization after application launch.
        return true
    }

}

