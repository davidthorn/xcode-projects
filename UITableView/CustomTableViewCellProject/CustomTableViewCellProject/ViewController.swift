//
//  ViewController.swift
//  CustomTableViewCellProject
//
//  Created by David Thorn on 27.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageUrl1: URL = URL(string: "https://picsum.photos/400/300?i=1")!
    var imageUrl2: URL = URL(string: "https://picsum.photos/400/300?i=2")!
    
    
    var image1: UIImage?
    var image2: UIImage?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.dataSource = self
        self.tableview.register(CustomTableViewCell.nib, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        // Do any additional setup after loading the view.
    }


}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell
        cell.authorLabel.text = "David Thorn"
        cell.titleLabel.text = "Our Changing Planet"
        cell.cardDescription.text = "Visit ten places on our planet that you think are interesting and not completed poluted. Otherwise you can visit Dortmund and is amazing footbal stadium, Heja BVB!"
        cell.cardImage.contentMode = .scaleAspectFill
        switch indexPath.row {
        case 0:
            guard let img1 = self.image1 else {
                return self.downloadImage(imageNumber: 1 , cell: cell , indexPath: indexPath)
            }
            
            cell.cardImage.image = img1
        case 1:
            guard let img2 = self.image2 else {
                return self.downloadImage(imageNumber: 2 , cell: cell , indexPath: indexPath)
            }
            
            cell.cardImage.image = img2
        default: fatalError()
            
        }
        
        return cell
    
    }
    
    func downloadImage(imageNumber: Int , cell: CustomTableViewCell , indexPath: IndexPath) -> CustomTableViewCell {
        
        let url = imageNumber == 1 ? self.imageUrl1 : self.imageUrl2
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let rawData = data else {
                return
            }
            
            guard let image = UIImage.init(data: rawData) else {
                return
            }
            
            DispatchQueue.main.async {
                switch imageNumber {
                case 1:
                    self.image1 = image
                case 2:
                    self.image2 = image
                default: fatalError()
                }
                self.tableview.reloadRows(at: [indexPath], with: .automatic)
            }
            
            
        }.resume()
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}
