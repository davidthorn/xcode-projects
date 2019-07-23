//
//  AppDelegate.swift
//  RavootoApp
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import MainFeature

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var loader: MainFeatureLoader = {
        let l = MainFeatureLoader.init()
        return l
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.rootViewController = UINavigationController.init(rootViewController: self.loader.load())
        self.window?.makeKeyAndVisible()
        return true
    }

    

}

