//
//  Tile.swift
//  TicTacToe
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public enum Tile: String, Codable {
    
    public static func create(rawValue: Int) -> Tile {
        switch rawValue {
        case 0: return .zero
        case 1: return .one
        case 2: return .two
        case 3: return .three
        case 4: return .four
        case 5: return .five
        case 6: return .six
        case 7: return .seven
        case 8: return .eight
        default: fatalError()
        }
    }
    
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    public var number: Int {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        }
    }
}
