//
//  MainFeatureLoader.swift
//  MainFeature
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation
import TabBarController
import MapController

public class MainFeatureLoader {
    
    public init() {
        
        
    }
    
    public func load() -> TabBarController {
        
        let controller = TabBarController.instance()
        controller.set(controllers: [
               map()
            ])
        
        return controller
        
    }
    
    internal func map() -> TabBarControllerItem {
        
        let button = UITabBarItem.init(tabBarSystemItem: .search, tag: 0)
        button.title = "Map"
        
        let item = TabBarControllerItem.init(item: button, controller: nil, isAsync: true, load: { (cb) in
            let vc = MapViewController.instance()
            cb(vc)
        }, loadingView: nil)
        
        return item
        
    }
    
}
