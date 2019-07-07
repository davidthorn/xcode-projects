//
//  AppDelegate.swift
//  FirebasePromisesApp
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

