//
//  GameButton.swift
//  TicTacToe
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class GameButton: UIButton {

    func update(canPlay: Bool) {
        let label = self.titleLabel ?? UILabel.init()
        let t = label.text ?? ""
        self.isEnabled = canPlay ? !["O" , "X"].contains(t) :  false
    }
    
    func set(title: String) {
        setTitleColor(.black, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 40)
        isEnabled = false
    }
}
