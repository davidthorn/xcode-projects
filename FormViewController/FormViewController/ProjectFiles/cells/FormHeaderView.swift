//
//  FormHeaderView.swift
//  FormViewController
//
//  Created by David Thorn on 30.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class FormHeaderView: UITableViewHeaderFooterView {

    static  var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle.init(for: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: self.reuseIdentifier, bundle: bundle)
    }
   
    @IBOutlet weak var mainTitle: UILabel!
    
}
