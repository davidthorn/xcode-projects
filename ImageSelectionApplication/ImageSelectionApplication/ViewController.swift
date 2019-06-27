//
//  ViewController.swift
//  ImageSelectionApplication
//
//  Created by David Thorn on 27.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    public var imagePickerController: UIImagePickerController?
    
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
        self.selectImageButton.isEnabled = self.selectedImage == nil
        self.selectImageButton.alpha = 1
    }

    @IBAction func selectImageButtonAction(_ sender: UIButton) {
        /// present image picker
        
        if self.imagePickerController != nil {
            self.imagePickerController?.delegate = nil
            self.imagePickerController = nil
        }
        
        self.imagePickerController = UIImagePickerController.init()
        
        let alert = UIAlertController.init(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
                self.presentImagePicker(controller: self.imagePickerController!, source: .camera)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction.init(title: "Photo Library", style: .default, handler: { (_) in
                self.presentImagePicker(controller: self.imagePickerController!, source: .photoLibrary)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction.init(title: "Saved Albums", style: .default, handler: { (_) in
                self.presentImagePicker(controller: self.imagePickerController!, source: .savedPhotosAlbum)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
        
    }
    
    internal func presentImagePicker(controller: UIImagePickerController , source: UIImagePickerController.SourceType) {
        controller.delegate = self
        controller.sourceType = source
        self.present(controller, animated: true)
    }
    
    @IBAction func removeImageButtonAction(_ sender: UIButton) {
        self.selectedImage = nil
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        
        self.selectedImage = image
        
        picker.dismiss(animated: true) {
            picker.delegate = nil
            self.imagePickerController = nil
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            picker.delegate = nil
            self.imagePickerController = nil
        }
    }
    
}
