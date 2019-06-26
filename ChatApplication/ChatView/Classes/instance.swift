//
//  instance.swift
//  ChatView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

extension ChatViewController {
    
    public static var storyboard: UIStoryboard {
        return UIStoryboard.init(name: "ChatView", bundle: Bundle.init(for: self))
    }
    
    public static func instance(datasource: ChatViewDatasourceProtocol! , delegate: ChatViewDelegateProtocol)  -> ChatViewController? {
        let vc = storyboard.instantiateInitialViewController() as? ChatViewController
        vc?.datasource = datasource
        vc?.delegate = delegate
        return vc
    }
    
    public func inNavigationController() -> UINavigationController {
        let nav = UINavigationController.init(rootViewController: self)
        
        return nav
    }
    
}
