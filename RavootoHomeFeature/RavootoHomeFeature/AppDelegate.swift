//
//  AppDelegate.swift
//  RavootoHomeFeature
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import RavootoHome

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.rootViewController = UINavigationController.init(rootViewController: RavootoHomeViewController.instance())
        self.window?.makeKeyAndVisible()
        return true
    }

  


}

