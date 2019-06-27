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
    
    internal var selectedImage: UIImage? {
        get {
            return self.selectedImageView.image
        }
        
        set {
            switch newValue {
            case nil:
                self.selectedImageView.image = nil
                self.selectImageButton.isEnabled = true
                self.selectImageButton.alpha = 1
                
                self.removeImageButton.isEnabled = false
                self.removeImageButton.alpha = 0.5
            default:
                self.selectedImageView.image = newValue
                self.selectImageButton.isEnabled = false
                self.selectImageButton.alpha = 0.5
                
                self.removeImageButton.isEnabled = true
                self.removeImageButton.alpha = 1
            }
        }
    }
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
        self.selectedImageView.contentMode = .scaleAspectFill
        self.selectImageButton.isEnabled = self.selectedImageView.image == nil
        self.selectImageButton.alpha = 1
    }

    @IBAction func selectImageButtonAction(_ sender: UIButton) {
        /// present image picker
    }
    
    @IBAction func removeImageButtonAction(_ sender: UIButton) {
        self.selectedImage = nil
    }
    
}
