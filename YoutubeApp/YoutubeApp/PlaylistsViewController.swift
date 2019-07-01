//
//  PlaylistsViewController.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class PlaylistsViewController: UIViewController {
    
    lazy var imageCache: NSCache<NSString, UIImage> = {
       return NSCache<NSString,UIImage>()
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    var playlists: [Playlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(PlayListTableViewCell.nib, forCellReuseIdentifier: PlayListTableViewCell.reuseIdentifier)
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.loadItems { (playlists) in
            self.playlists = playlists
            print(playlists.first?.id)
            self.tableview.reloadData()
        }
    }

}

extension PlaylistsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = playlists[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: PlayListTableViewCell.reuseIdentifier, for: indexPath) as! PlayListTableViewCell
        cell.playlist = item
        
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
        return self.playlists.count
    }

    internal func loadImage(url: URL , item: Playlist , cell: PlayListTableViewCell, indexPath: IndexPath ) -> UITableViewCell {
        
        URLSession.shared.dataTask(with: url) { (imageData, _, _) in
            
            guard let data = imageData else {
                return
            }
            
            guard let image = UIImage.init(data: data) else { return }
            
            self.imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
            
            DispatchQueue.main.async {
                let contains = self.tableview.indexPathsForVisibleRows?.first(where: { $0 == indexPath })
                guard let path = contains, let visCell = self.tableview.cellForRow(at: path) as? PlayListTableViewCell  else { return }
                visCell.playlistImage.image = image
            }
        }.resume()
        
        return cell
        
    }
    
}

extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = playlists[indexPath.row]
        PlaylistViewController.present(item: item, controller: self.navigationController!)
    }
    
}

extension PlaylistsViewController {
    
    internal func loadItems(completion: @escaping (_ items: [Playlist]) -> Void) {
        URLSession.shared.dataTask(with: PLAYLISTS_URL) { (data, _, _) in
            
            guard let jsonData = data else {
                fatalError("This is an error")
            }
            
            do {
                //print(String(data: jsonData, encoding: .utf8)!)
                let playlists = try JSONDecoder().decode(Playlists.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(playlists.items)
                }
            } catch let erro {
                print(erro.localizedDescription)
            }
            
            }.resume()
    }
    
}
