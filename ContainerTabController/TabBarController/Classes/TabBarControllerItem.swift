//
//  TabBarControllerItem.swift
//  TabBarController
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

public struct TabBarControllerItem {
    public typealias TabBarControllerItemAysncHandler = (_ completion: @escaping (_ controller: UIViewController? ) -> Void ) -> Void
    public let item: UITabBarItem
    public var controller: UIViewController?
    public let isAsync: Bool
    public var load: TabBarControllerItemAysncHandler?
    public var loadingView: UIView?
    
    public init(item: UITabBarItem , controller: UIViewController? , isAsync: Bool = false , load: TabBarControllerItemAysncHandler? = nil , loadingView: UIView? = nil) {
        self.item = item
        self.controller = controller
        self.isAsync = isAsync
        self.load = load
        self.loadingView = loadingView
    }
}
