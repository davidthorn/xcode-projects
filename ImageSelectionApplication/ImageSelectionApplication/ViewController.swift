//
//  ViewController.swift
//  ImageSelectionApplication
//
//  Created by David Thorn on 27.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    public var defaultImageUrl: URL?
    
    @IBOutlet weak var selectedImageContainer: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var selectImageButton: UIButton! {
        didSet {
            guard let button = self.selectImageButton else { return }
            button.isEnabled = true
            button.alpha = 1
        }
    }
    
    @IBOutlet weak var removeImageButton: UIButton! {
        didSet {
            guard let button = self.removeImageButton else { return }
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectImageButton.isEnabled = self.selectedImageView.image == nil
        self.selectImageButton.alpha = 1
        // Do any additional setup after loading the view.
    }

    @IBAction func selectImageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func removeImageButtonAction(_ sender: UIButton) {
    
    }
    
}

