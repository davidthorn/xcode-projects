//
//  ViewController.swift
//  ImageDownloader
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

let downloadUrl: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/a2/Porsche_911_No_1000000%2C_70_Years_Porsche_Sports_Car%2C_Berlin_%281X7A3888%29.jpg")!

class ViewController: UIViewController {
    
    var count: Int = 0
    
    @IBOutlet weak var counter: UILabel!
    
    lazy var que: DispatchQueue = {
        return DispatchQueue.init(label: "ViewController.background" , attributes: .concurrent)
    }()
    
    lazy var que1: DispatchQueue = {
        return DispatchQueue.init(label: "ViewController.background.1" , attributes: .concurrent)
    }()
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var imageContainer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doCount()
        
//        self.que1.async {
//            let image = UIImage.init(data: try! Data(contentsOf: downloadUrl))
//            DispatchQueue.main.async {
//                self.imageContainer.image = image
//            }
//        }
        
       
        
    }
    
    func doCount() {
        
        self.que.async {
            repeat {
                usleep(500)
                self.count += 1
                DispatchQueue.main.async {
                    self.counter.text = "Counter \(self.count) "
                }
            } while true
        }
    }

    @IBAction func downloadAction(_ sender: Any) {
        self.downloadButton.isEnabled = false
        
        URLSession.shared.dataTask(with: downloadUrl) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                fatalError("something went wrong here")
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let imageData = data else {
                    fatalError("not image data")
                }
                
                guard let image = UIImage.init(data: imageData) else {
                    fatalError("not valid image data")
                }
                
                DispatchQueue.main.async {
                    self.imageContainer.image = image
                    self.downloadButton.isEnabled = true
                    self.counter.text = "Counter \(self.count) "
                }
                
            default:
                fatalError("not 200 response provided")
            }
            
        }.resume()
    }
    
}

