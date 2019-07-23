//
//  Array+update.swift
//  TabBarController
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

extension Array where Element == TabBarControllerItem {
    
    func update(item: UITabBarItem , with controller: UIViewController) -> Array<TabBarControllerItem> {
        return self.map { controllerItem in
            if controllerItem.item == item {
                var a = controllerItem
                a.controller = controller
                return a
            }
            return controllerItem
        }
    }
    
}
