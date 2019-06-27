//
//  CustomTableViewCell.swift
//  CustomTableViewCellProject
//
//  Created by David Thorn on 27.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toolbarWrapper: UIView!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    
    static var reuseIdentifier: String {
        return "customCell"
    }
    
    static var nib: UINib? {
        return UINib.init(nibName: "CustomTableViewCell", bundle: Bundle.init(for: CustomTableViewCell.self))
    }
  
}
