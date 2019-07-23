//
//  AppDelegate.swift
//  EurekaFormExample
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import ProfileModule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var navigationController: UINavigationController? {
        return self.window?.rootViewController as? UINavigationController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let schema = url.scheme , schema == "auth" else { return false }
        
        guard let host = url.host else { return false }
        
        switch host {
        case "login":
            print("login request")
        case "profile":
            print("profile request")
            let vc = ProfileViewController.instance(from: url)
            self.navigationController?.pushViewController(vc!, animated: true)
        case "changeEmail":
            print("changeEmail request")
        case "changePassword":
            print("changePassword request")
        default: return false
        }
        
        return true
    }
    
}

