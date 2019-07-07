//
//  Players.swift
//  TicTacToe
//
//  Created by David Thorn on 06.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct Players: Codable {
    
    public let x: PlayerId?
    public let o: PlayerId?
    
    public var hasX: Bool {
        return self.x != nil
    }
    
    public var hasO: Bool {
        return self.o != nil
    }
    
    public func isX(id: String) -> Bool {
        guard let _x = x else{ return false }
        return _x == id
    }
    
    public func isO(id: String) -> Bool {
        guard let _o = o else{ return false }
        return _o == id
    }
    
    public func userMarker(id: String) -> String? {
        if isX(id: id) { return "X" }
        if isO(id: id) { return "O" }
        return nil
    }
    
}

extension Players: Equatable {
    
    public static func ==(lhs: Players , rhs: Players) -> Bool {
        return lhs.x == rhs.x && lhs.o == rhs.o
    }
    
}
