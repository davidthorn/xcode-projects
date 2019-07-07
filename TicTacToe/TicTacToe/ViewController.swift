//
//  ViewController.swift
//  TicTacToe
//
//  Created by David Thorn on 05.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {

    
    
    @IBAction func startGameAction(_ sender: Any) {
    
        try! Auth.auth().signOut()
        
        Auth.auth().signIn(withEmail: "test@gmail.com", password: "123456") { (result, _) in
            
            var uints: [UInt] = []
            
            guard let id = result?.user.uid else {
                return print("could not get user id")
            }
            
            let startGame = StartGame.init(player: .x, uid: id)
            
            let ref = Database.database().reference(withPath: "/start").childByAutoId()
            
            let gameRef = Database.database().reference(withPath: "/games").child(ref.key!)
            
            gameRef.keepSynced(true)
            gameRef.observe(.value, with: { (snap) in
                guard snap.exists(), let gameData = snap.value as? NSDictionary else{
                    return
                }
                let game = Game.parse(dict: gameData)
                
                ref.removeAllObservers()
                gameRef.removeAllObservers()
                print("the game was created" , game)
            })
            
            let b = ref.observe(.childRemoved, with: { (snap) in
                print("the start game was removed")
            })
            
            ref.setValue(startGame.dictionary(), withCompletionBlock: { (error, _) in
                print("the data was created" , error?.localizedDescription)
                
                
            })
            
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

