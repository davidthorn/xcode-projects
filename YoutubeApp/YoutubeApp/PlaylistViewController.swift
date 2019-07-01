//
//  PlaylistViewController.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var playlist: Playlist!
    
    lazy var imageCache: NSCache<NSString, UIImage> = {
        return NSCache<NSString,UIImage>()
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    var playlistItems: [PlaylistItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(PlayListItemTableViewCell.nib, forCellReuseIdentifier: PlayListItemTableViewCell.reuseIdentifier)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.loadItems { (playlistItems) in
            self.playlistItems = playlistItems
            self.tableview.reloadData()
        }
    }
    
}

extension PlaylistViewController {
    
    public static func present(item: Playlist , controller: UINavigationController) {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: PlaylistViewController.self))
        let vc = sb.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
        vc.playlist = item
        controller.pushViewController(vc, animated: true)
    }
    
}

extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = playlistItems[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: PlayListItemTableViewCell.reuseIdentifier, for: indexPath) as! PlayListItemTableViewCell
        cell.item = item
        
        guard let url = item.snippet.thumbnails.high?.url else {
            return cell
        }
        
        guard let image = self.imageCache.object(forKey: NSString(string: url.absoluteString)) else {
            return self.loadImage(url: url, item: item, cell: cell, indexPath: indexPath)
        }
        
        cell.playlistImage.image = image
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistItems.count
    }
    
    internal func loadImage(url: URL , item: PlaylistItem , cell: PlayListItemTableViewCell, indexPath: IndexPath ) -> UITableViewCell {
        
        URLSession.shared.dataTask(with: url) { (imageData, _, _) in
            
            guard let data = imageData else {
                return
            }
            
            guard let image = UIImage.init(data: data) else { return }
            
            self.imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
            
            DispatchQueue.main.async {
                let contains = self.tableview.indexPathsForVisibleRows?.first(where: { $0 == indexPath })
                guard let path = contains, let visCell = self.tableview.cellForRow(at: path) as? PlayListItemTableViewCell  else { return }
                visCell.playlistImage.image = image
            }
            }.resume()
        
        return cell
        
    }
    
}

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension PlaylistViewController {
    
    internal func loadItems(completion: @escaping (_ items: [PlaylistItem]) -> Void) {
        URLSession.shared.dataTask(with: PLAYLIST_URL(playlistId: self.playlist.id)) { (data, _, _) in
            
            guard let jsonData = data else {
                fatalError("This is an error")
            }
            
            do {
                print(String(data: jsonData, encoding: .utf8)!)
                let playlists = try JSONDecoder().decode(PlaylistItems.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(playlists.items.sorted(by: { l,r in l.snippet.position < r.snippet.position }))
                }
            } catch let erro {
                print(erro.localizedDescription)
            }
            
            }.resume()
    }
    
}
