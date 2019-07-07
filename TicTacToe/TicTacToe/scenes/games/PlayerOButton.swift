//
//  PlayerOButton.swift
//  TicTacToe
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class PlayerOButton: UIButton {
    
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
        
        if game.players.isX(id: userId) || game.players.isO(id: userId) {
            self.isEnabled = false
        } else {
            self.isEnabled = true
        }
        
        switch isEnabled {
        case true:
            addTarget(self, action: #selector(joinGame), for: UIControl.Event.touchUpInside)
        case false:
            removeTarget(self, action: #selector(joinGame), for: UIControl.Event.touchUpInside)
        }
        
        switch game.players.hasO {
        case true:
            backgroundColor = game.nextMove == game.players.o! ? .green : .lightGray
        case false:
            backgroundColor = .gray
        }
        
    }
    
    @objc func joinGame() {
        self.game.join(type: .o, userId: self.userId) { game in
            print("joined game: \(game?.players.isO(id: self.userId))")
        }
    }
}
