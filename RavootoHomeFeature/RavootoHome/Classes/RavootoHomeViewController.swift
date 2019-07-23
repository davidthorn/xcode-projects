//
//  RavootoHomeViewController.swift
//  RavootoHome
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

open class RavootoHomeViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            guard let button = self.registerButton else { return }
            button.backgroundColor = UIColor.orange
            button.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            guard let button = self.startButton else { return }
            button.backgroundColor = UIColor.purple
            button.layer.cornerRadius = 5
        }
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
    
    }
    
}

extension RavootoHomeViewController {
    
    public static func instance() -> RavootoHomeViewController {
        let sb = UIStoryboard.init(name: "RavootoHome", bundle: Bundle.init(for: RavootoHomeViewController.self))
        let vc = sb.instantiateInitialViewController() as! RavootoHomeViewController
        
        return vc
    }
    
}
