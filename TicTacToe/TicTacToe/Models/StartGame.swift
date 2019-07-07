//
//  StartGame.swift
//  TicTacToe
//
//  Created by David Thorn on 06.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct StartGame: Codable {
    public let player: PlayerType
    public let uid: String
}

extension StartGame {
    
    public func dictionary() -> NSDictionary {
        let data = try! JSONEncoder.init().encode(self)
        let dict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return dict as! NSDictionary
    }
    
}
