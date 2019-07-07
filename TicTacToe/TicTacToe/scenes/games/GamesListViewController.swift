//
//  GamesListViewController.swift
//  TicTacToe
//
//  Created by David Thorn on 06.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

open class GamesListViewController: UIViewController {

    var user: User!
    
    @IBAction func startGameAction(_ sender: Any) {
        let startGame = StartGame.init(player: .x, uid: self.user.uid)
        let ref = Database.database().reference(withPath: "/start").childByAutoId()
        ref.setValue(startGame.dictionary(), withCompletionBlock: { (error, _) in
            guard error == nil else {
                fatalError("could not start game")
            }
            
            self.background.async {
                let game = Game.ready(id: ref.key!)
                DispatchQueue.main.async {
                    let vc = GameViewController.instance(game: game, user: self.user)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    var games: [Game] = []
    
    @IBAction func logoutAction(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    var numberOfGames: Int {
        return queue.sync {
            return games.count
        }
    }
    
    func get(index: IndexPath) -> Game {
        return queue.sync {
            return games[index.row]
        }
    }
    
    func add(game: Game) {
        let contains = self.queue.sync {
           return self.games.contains(game)
        }
        
        guard !contains else { return print("ignoring game: \(game)") }
        
        DispatchQueue.main.async {
            self.tableview.beginUpdates()
            let indexPath = IndexPath.init(row: self.numberOfGames, section: 0)
            self.tableview.insertRows(at: [indexPath], with: .automatic)
            self.queue.sync {
                self.games.append(game)
            }
            self.tableview.endUpdates()
        }
    }
    
    func remove(game: Game) {
        DispatchQueue.main.async {
            self.tableview.beginUpdates()
            
            let firstIndex = self.queue.sync {
                return self.games.firstIndex(where: { $0 == game })
            }
            
            guard let index = firstIndex else{ return }
            self.tableview.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
            _ = self.queue.sync {
                self.games.remove(at: index)
            }
            self.tableview.endUpdates()
        }
    }
    
    lazy var queue: DispatchQueue = {
        return DispatchQueue.init(label: "games.queue")
    }()
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "games.background.queue" , attributes: .concurrent)
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Games List"
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.background.async {
            
            let games = Game.all()
            print("returned from games loading", games)
            DispatchQueue.main.async {
                self.queue.sync {
                    self.games = games
                }
                
                self.tableview.reloadData()
                
                _ = Game.added(completion: { (game) in
                    self.add(game: game)
                })
                
                
            }
        }
    }

    public static func instance(user: User) -> GamesListViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "GamesListViewController") as! GamesListViewController
        vc.user = user
        return vc
    }
    
}

extension GamesListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = get(index: indexPath)
        let cell = tableview.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = game.id
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
}

extension GamesListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = get(index: indexPath)
        
        switch game.amPlaying(id: self.user.uid) {
        case true:
            let vc = GameViewController.instance(game: game, user: self.user)
            self.navigationController?.pushViewController(vc, animated: true)
        case false:
            let alert = UIAlertController.init(title: "What you want to do?", message:nil, preferredStyle: .actionSheet)
            alert.addAction(joinGameAction(game: game, user: user))
            alert.addAction(viewGameAction(game: game, user: user))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
            self.present(alert, animated: true) {
                print("was presented")
            }
        }
    }
    
    func viewGameAction(game: Game , user: User) -> UIAlertAction {
        return UIAlertAction.init(title: "View", style: .default, handler: { (_) in
            let vc = GameViewController.instance(game: game, user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func joinGameAction(game: Game , user: User) -> UIAlertAction {
        return UIAlertAction.init(title: "Join", style: .default, handler: { (_) in
            
            game.join(type: .o, userId: user.uid) { joinedGame in
                
                guard let gameToPlay = joinedGame else { return }
                
                switch gameToPlay.amPlaying(id: self.user.uid) {
                case true:
                    self.games = self.games.map { l in
                        if l.id == gameToPlay.id {
                            return gameToPlay
                        }
                        return l
                    }
                    self.tableview.reloadData()
                    let vc = GameViewController.instance(game: gameToPlay, user: user)
                    self.navigationController?.pushViewController(vc, animated: true)
                case false:
                    fatalError("not playing, possible transation problem")
                }
            }
            
        })
    }
    
}
