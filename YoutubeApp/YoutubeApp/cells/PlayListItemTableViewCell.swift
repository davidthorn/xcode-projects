//
//  PlayListItemTableViewCell.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class PlayListItemTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib? {
        return UINib.init(nibName: reuseIdentifier, bundle: bundle)
    }
    
    static var bundle: Bundle {
        return Bundle.init(for: self)
    }
    
    var item: PlaylistItem! {
        didSet {
            guard let item = self.item else { return }
            let s = item.snippet
            playlistItem.text = s.title
            playlistPublishAt.text = "Published At: \(s.publishedAt)"
            playlistDescription.text = s.description
        }
    }
    
    @IBOutlet weak var playlistItem: UILabel!
    @IBOutlet weak var playlistImageWrapper: UIView!
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistDescription: UILabel!
    @IBOutlet weak var playlistPublishAt: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
        playlistItem.text = nil
        playlistPublishAt.text = nil
        playlistDescription.text = nil
        playlistImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playlistImageWrapper.clipsToBounds = true
    }
    
}
