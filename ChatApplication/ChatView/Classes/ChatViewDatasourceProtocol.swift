//
//  ChatViewDatasourceProtocol.swift
//  ChatView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public protocol ChatViewDatasourceProtocol {
    
    /// Should be called to load the initial items for the chat view
    func load(completion: @escaping (_ items: [CellItem] , _ realTimeDatasource: ChatViewRealtimeDatasourceProtocol ) -> Void)
    
}
