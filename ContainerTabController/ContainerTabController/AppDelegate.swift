//
//  AppDelegate.swift
//  ContainerTabController
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import TabBarController

class TextViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instance(color: UIColor) -> TextViewController {
        let v = TextViewController.init()
        v.view.backgroundColor = color
        return v
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("the view did appear for background color: \(String(describing: self.view.backgroundColor))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("the viewDidDisappear for background color: \(String(describing: self.view.backgroundColor))")
    }
    
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let sb = (UIStoryboard.init(name: "TabBarController", bundle: Bundle.init(for: TabBarController.self)))
        let vc = sb.instantiateInitialViewController() as? TabBarController
        
        vc?.set(controllers: [
            
            TabBarControllerItem.init(item: UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1), controller: TextViewController.instance(color: .gray), isAsync: false, load: nil),
            TabBarControllerItem.init(item: UITabBarItem.init(tabBarSystemItem: .search, tag: 0), controller: nil, isAsync: true, load: { cb in
                
                DispatchQueue.global(qos: .background).async {
                    Thread.sleep(forTimeInterval: 5)
                    DispatchQueue.main.async {
                        let vc = TextViewController.instance(color: .red)
                        cb(vc)
                    }
                }
                
            }),
            TabBarControllerItem.init(item: UITabBarItem.init(tabBarSystemItem: .search, tag: 2), controller: TextViewController.instance(color: .orange)),
            TabBarControllerItem.init(item: UITabBarItem.init(tabBarSystemItem: .search, tag: 3), controller: TextViewController.instance(color: .purple)),
            TabBarControllerItem.init(item: UITabBarItem.init(tabBarSystemItem: .contacts, tag: 5), controller: TextViewController.instance(color: .cyan))
            ])
        
        self.window?.rootViewController = UINavigationController.init(rootViewController: vc!)
        self.window?.makeKeyAndVisible()
        return true
    }

   

}

