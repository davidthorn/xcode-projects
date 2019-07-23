//
//  AppDelegate.swift
//  FirebaseDataSnapShot
//
//  Created by David Thorn on 08.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        var uint: UInt?
        var data: Any?
        
        
        let games: DatabaseReference  = Database.database().reference(withPath: "games")
       
        uint = games.observe(.value) { (snap) in
            
            guard data == nil  else { return print("this should not be called any more") }
            data = true
            snap.ref.removeObserver(withHandle: uint!)
            
            let snaps = snap.children.allObjects.compactMap({ $0 as? DataSnapshot  })
            let dicts = snaps.compactMap({ $0.value as? NSDictionary })
            
            print(dicts)
        }
        
        
        return true
    }

   

}

