//
//  instance.swift
//  EmailPasswordLoginView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

extension EmailPasswordLoginViewController {
    
    public static var storyboard: UIStoryboard {
        return UIStoryboard.init(name: "EmailPasswordLoginView", bundle: Bundle.init(for: self))
    }
    
    public static func instance(delegate: EmailPasswordLoginViewDelegateProtocol , defaultEmailString: String? = nil) -> EmailPasswordLoginViewController? {
        let vc = storyboard.instantiateInitialViewController() as? EmailPasswordLoginViewController
        vc?.delegate = delegate
        vc?.defaultEmail = defaultEmailString
        return vc
    }
    
    public func inNavigationController() -> UINavigationController {
        let nav = UINavigationController.init(rootViewController: self)
        
        return nav
    }
    
}
