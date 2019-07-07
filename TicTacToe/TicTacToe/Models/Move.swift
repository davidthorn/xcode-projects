//
//  Move.swift
//  TicTacToe
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct Move: Codable {
    public let tile: Tile
    public let uid: String
}
