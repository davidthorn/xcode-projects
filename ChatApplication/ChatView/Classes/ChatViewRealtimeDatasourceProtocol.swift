//
//  ChatViewRealtimeDatasourceProtocol.swift
//  ChatView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public protocol ChatViewRealtimeDatasourceProtocol {
    
    /// Will be called every time a new message has been added to the chat room / conversation
    var onAdded: ((_ item: CellItem) -> Void)?{ get set }
    
    /// Will be called every time a new message has been deleted in the chat room / conversation
    var onDeleted: ((_ item: CellItem) -> Void)?{ get set }
    
    /// Will be called every time a message has been changed in the chat room / conversation
    var onChanged: ((_ item: CellItem) -> Void)?{ get set }
    
}
