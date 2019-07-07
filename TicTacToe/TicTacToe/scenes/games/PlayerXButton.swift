//
//  PlayerXButton.swift
//  TicTacToe
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class PlayerXButton: UIButton {

    var userId: String!
    var game: Game!
    
    func listen(game: Game , userId: String) {
        self.game = game
        self.userId = userId
        
        update(game: game, userId: userId)
        _ = game.changed { [weak self](_g , uint) in
            guard let _game = _g else { return }
            self?.game = _game
            self?.update(game: _game, userId: userId)
        }
    }
    
    func update(game: Game , userId: String) {
        
        self.isEnabled = !game.players.hasX
        
        switch isEnabled {
        case true:
            addTarget(self, action: #selector(joinGame), for: UIControl.Event.touchUpInside)
        case false:
            removeTarget(self, action: #selector(joinGame), for: UIControl.Event.touchUpInside)
        }
        
        switch game.players.hasX {
        case true:
            backgroundColor = game.nextMove == game.players.x! ? .green : .lightGray
        case false:
            backgroundColor = .gray
        }

    }
    
    @objc func joinGame() {
        self.game.join(type: .x, userId: self.userId) { game in
            print("joined game: \(game?.players.isX(id: self.userId))")
        }
    }
}
