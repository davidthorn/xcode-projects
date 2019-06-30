//
//  InputRowCell.swift
//  FormViewController
//
//  Created by David Thorn on 30.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class InputRowCell: UITableViewCell {

    var element: FormElement!
    
    static  var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle.init(for: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: self.reuseIdentifier, bundle: bundle)
    }
   
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var inputFieldLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.inputField.layer.borderWidth = 1
        self.inputField.layer.borderColor = UIColor.lightGray.cgColor
        self.inputField.layer.cornerRadius = 10
        let lv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: self.inputField.bounds.height))
        self.inputField.leftView = lv
        self.inputField.leftViewMode = .always
    }
    
}
