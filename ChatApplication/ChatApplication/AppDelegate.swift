//
//  AppDelegate.swift
//  ChatApplication
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import ChatView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var items: [CellItem] = []
    
    var _onAdded: ((CellItem) -> Void)?
    var _onChanged: ((CellItem) -> Void)?
    var _onDeleted: ((CellItem) -> Void)?
    
    var window: UIWindow?
    
    lazy var chatView: ChatViewController! = {
        let vc = ChatViewController.instance(datasource: self, delegate: self)
        
        return vc
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.rootViewController = chatView.inNavigationController()
        self.window?.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate: ChatViewDatasourceProtocol, ChatViewRealtimeDatasourceProtocol {
    
    var onAdded: ((CellItem) -> Void)? {
        get {
            return _onAdded
        }
        set(newValue) {
            _onAdded = newValue
        }
    }
    
    var onDeleted: ((CellItem) -> Void)? {
        get {
            return _onDeleted
        }
        set(newValue) {
            _onDeleted = newValue
        }
    }
    
    var onChanged: ((CellItem) -> Void)? {
        get {
            return _onChanged
        }
        set(newValue) {
            _onChanged = newValue
        }
    }
    
    
    func load(completion: @escaping ([CellItem], ChatViewRealtimeDatasourceProtocol) -> Void) {
        
        let items = (0...100).enumerated().map{ return "\($0)" }
        self.items = items
        completion(items , self)
        
        self.onAdded?("two")
        self.onChanged?("one")
        self.onDeleted?("one")
        
    }
    
}

extension AppDelegate: ChatViewDelegateProtocol {
    
    func sendMessage(text: String, completion: @escaping (ChatViewError?) -> Void) {
        self.onAdded?(text)
        self.items.append(text)
        completion(nil)
    }
    
}
