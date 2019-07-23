//
//  TabBarController.swift
//  TabBarController
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

open class TabBarController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarWrapper: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    internal var preViewDidLoadControllers: [TabBarControllerItem]?
    
    public var controllers: [TabBarControllerItem] {
        return self._controllers
    }
    
    internal var _controllers: [TabBarControllerItem] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let vcs = self.preViewDidLoadControllers {
            self.set(controllers: vcs)
            self.preViewDidLoadControllers = nil
        }
        
        self.tabBar.delegate = self
        guard let first = self.controllers.first else { return }
        self.setSelected(item: first)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarWrapper.backgroundColor = UIColor.darkGray
    }
    
    internal func setSelected(item: TabBarControllerItem) {
        
        switch item.isAsync {
        case true:
            
            guard item.controller == nil else {
                return self.setView(itemView: item.controller?.view)
            }
            
            item.load? { vc in
                guard let vc = vc else { return }
                self._controllers = self._controllers.update(item: item.item, with: vc)

                self.addChild(vc)
                guard let selectedItem = self.tabBar.selectedItem else { return }
                guard let visibleItem = self.controllers.first(where: { $0.item == selectedItem }) else { return }
                switch item.item == visibleItem.item {
                case true:
                    self.setView(itemView: vc.view)
                case false: break}
                
            }
        case false:
            self.setView(itemView: item.controller?.view)
        }
    }
    
    internal func setView(itemView: UIView? ) -> Void {
        self.contentView.subviews.forEach { i in
            i.removeFromSuperview()
        }
        guard let _view = itemView else {
            fatalError("No available to be added")
        }
        _view.frame = self.contentView.bounds
        _view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        self.contentView.addSubview(_view)
    }
    
    public func set(controllers: [TabBarControllerItem]) {
        
        guard self.isViewLoaded else {
            self.preViewDidLoadControllers = controllers
            return
        }
        
        self._controllers.forEach { item in
            item.controller?.removeFromParent()
            item.controller?.view.removeFromSuperview()
        }
        self.tabBar.items?.removeAll()
        self.tabBar.selectedItem = nil
        
        controllers.forEach { controllerItem in
            self._controllers.append(controllerItem)
            self.tabBar.items?.append(controllerItem.item)
            guard let vc = controllerItem.controller else { return }
            self.addChild(vc)
        }
        let item = self.controllers.first!
        self.setSelected(item: item)
        self.tabBar.selectedItem = tabBar.items?.first
    }
}

extension TabBarController: UITabBarDelegate {
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let controllerItem = self.controllers.first(where: { $0.item == item }) else { return }
        print(controllerItem)
        self.setSelected(item: controllerItem)
    }
    
}

