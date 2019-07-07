//
//  WhosMoveLabel.swift
//  TicTacToe
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class WhosMoveLabel: UILabel {

    func listen(game: Game, userId: String) {
        
        update(game: game, userId: userId)
        _ = game.changed { [weak self](game, uint) in
            guard let _game = game else { fatalError("game should not be nil") }
            self?.update(game: _game, userId: userId)
        }
    }

    func update(game: Game, userId: String) {
        
        if let winner = game.winner {
            switch winner.uid {
            case "DRAW":
                self.text = "DRAW"
            default:
                self.text = "Winner: \(game.players.userMarker(id: winner.uid)!)"
            }
            return
        }
        
        switch game.canPlay() {
        case false:
            self.text = "Waiting for player"
            return
        default: break
        }

        switch game.canMove(id: userId) {
        case false:
            self.text = NextMoveText.theirs.rawValue
        case true:
            self.text = NextMoveText.yours.rawValue
        }
    }
}
