//
//  Game.swift
//  TicTacToe
//
//  Created by David Thorn on 06.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

public typealias PlayerId = String

public struct Winner: Codable {
    public let uid: String
    public let tiles: [Int]?
}

public struct Game: Codable {
    
    public let id: String
    public let nextMove: PlayerId
    public let players: Players
    public let startedAt: Double
    public let moves: [Move]?
    public let winner: Winner?
    
    public func marker() -> String {
        let uid = Auth.auth().currentUser!.uid
        return players.o == uid ? "O" : "X"
    }
    
    public func otherMarker() -> String {
        let uid = Auth.auth().currentUser!.uid
        return players.o == uid ? "X" : "O"
    }
    
    public func canPlay() -> Bool {
        
        if let _ = self.winner {
            return false
        }
        
        if self.players.x == nil || self.players.o == nil {
            return false
        }
        
        return true
    }
    
    public func canJoin() -> Bool {
        if let _ = self.winner {
            return false
        }
        return !self.players.hasO || !self.players.hasX
    }
    
    public func amPlaying(id: PlayerId ) -> Bool {
        return self.players.isO(id: id) || self.players.isX(id: id)
    }
    
    public func userMarker(id: String) -> String? {
        return self.players.userMarker(id: id)
    }
    
    public func canMove(id: String) -> Bool {
        if let _ = self.winner {
            return false
        }
        return self.nextMove == id
    }
    
}

extension Game: Equatable {
    
    public static func ==(lhs: Game , rhs: Game) -> Bool {
        return lhs.id == rhs.id && lhs.nextMove == rhs.nextMove && lhs.players == rhs.players && lhs.startedAt == rhs.startedAt
    }
    
}

extension Game {
    
    public static func parse(dict: NSDictionary) -> Game {
        let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return try! JSONDecoder.init().decode(self, from: data)
    }
    
}

extension Game {
    
    public static var allGamesReference: DatabaseReference {
        return Database.database().reference(withPath: "/games")
    }
    
    public static var joinGameReference: DatabaseReference {
        return Database.database().reference(withPath: "/join")
    }
    
    public static var moveGameReference: DatabaseReference {
        return Database.database().reference(withPath: "/move")
    }
    
    public static func all() -> [Game] {
        
        let group = DispatchGroup.init()
        group.enter()

        var games: [Game] = []

        allGamesReference.keepSynced(true)

        allGamesReference.observe(.value) { (snap) in
            games = snap.games
            group.leave()
        }

        group.wait()
        
        return games
        
    }
    
    public static func convertMoves(dicts: [NSDictionary]) -> [NSDictionary] {
        return dicts.map{ convertMoves(dict: $0) }
    }
    
    public static func convertMoves(dict: NSDictionary) -> NSDictionary {
        let movesKey: String = "moves"
        guard let moves = dict[movesKey] as? NSDictionary else { return dict }
        let v = moves.allValues.compactMap { $0 as? NSDictionary }
        let _d = NSMutableDictionary.init(dictionary: dict)
        _d[movesKey] = v
        return _d
    }
    
    public func changed(completion: @escaping (_ game: Game? , _ ref: UInt ) -> Void) -> DatabaseReference {
        
        var gameRef: UInt!
        
        let ref = Game.allGamesReference.child(self.id)
        
        ref.keepSynced(true)
        
        gameRef = ref.observe(.value) { (snap) in
            guard let game = snap.game else{ return completion(nil , gameRef) }
            completion(game , gameRef)
        }
        
        return ref
    }
    
    public static func added(completion: @escaping (_ game: Game ) -> Void) -> DatabaseReference {
        
        let query = allGamesReference.queryLimited(toLast: 1)
        
        query.keepSynced(true)
        
        query.observe(.childAdded) { (snap) in
            
            guard let game = snap.game else{ fatalError("Could not load the game")  }
            completion(game)
        }
        
        return query.ref
    }
    
    public func join(type: PlayerType , userId: PlayerId , completion: @escaping (_ game: Game?) -> Void) {
        
        var joined: Bool?
        var gameReference: DatabaseReference!
        
        let join = [
            "player" : type.rawValue,
            "uid" : userId
        ]
        
        gameReference = self.changed { (game , uint) in
            print("changed has been called")
            guard joined != nil else{ return }
            gameReference.removeObserver(withHandle: uint)
            guard let _game = game else { return completion(nil) }
            switch type {
            case .o:
                completion(_game.players.isO(id: userId) ? _game : nil)
            case .x:
                completion(_game.players.isX(id: userId) ? _game : nil)
            }
        }
        
        Game.joinGameReference.child(self.id).setValue(join) { (error, _) in
            
            guard error == nil else {
                print("could not join game, \(error!.localizedDescription)")
                return completion(nil)
            }
        
            joined = true
            print("waiting for the changed to be called")
        }
    }
    
    public func move(tile: Tile , userId: PlayerId) -> Bool {
        var canMove: Bool = false
        let group = DispatchGroup.init()
        group.enter()
        let join: [String: Any] = [
            "tile" : tile.rawValue,
            "uid" : userId
        ]
        Game.moveGameReference.child(self.id).setValue(join) { (error, _) in
            canMove = error == nil
            group.leave()
        }
        
        group.wait()
        
        return canMove
    }
    
    public static func ready(id: String) -> Game {
        let group = DispatchGroup.init()
        group.enter()
        var uint: UInt?
        var game: Game!
        let query = allGamesReference.child(id)
        
        query.keepSynced(true)
        uint = query.observe(.value) { (snap) in
            guard snap.exists() else{ return }
            guard let _game = snap.game else{ return  }
            snap.ref.removeObserver(withHandle: uint!)
            game = _game
            group.leave()
        }
        
        group.wait()
        return game
    }
    
    
}


extension DataSnapshot {
    
    public var game: Game? {
        
        guard let dict = self.value as? NSDictionary else{
            fatalError("game is not in the correct format, it must be a dictionary")
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: Game.convertMoves(dict: dict), options: .prettyPrinted)
            return try JSONDecoder.init().decode(Game.self, from: data)
        } catch {
            fatalError("could not decode game")
        }
    }
    
    public var games: [Game] {
        
        let dicts = children.allObjects.compactMap({ $0 as? DataSnapshot }).compactMap({$0.value as? NSDictionary})
        
        Game.allGamesReference.removeAllObservers()
        
        do {
           let data = try JSONSerialization.data(withJSONObject: Game.convertMoves(dicts: dicts) , options: .prettyPrinted)
            return try JSONDecoder.init().decode([Game].self, from: data)
        } catch {
            fatalError("Could not decode games")
        }
    }
    
}
