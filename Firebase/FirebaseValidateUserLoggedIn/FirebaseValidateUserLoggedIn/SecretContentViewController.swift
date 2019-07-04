//
//  SecretContentViewController.swift
//  FirebaseValidateUserLoggedIn
//
//  Created by David Thorn on 04.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseAuth

class SecretContentViewController: UIViewController {

    @IBAction func signoutUser(_ sender: Any) {
        try! Auth.auth().signOut()
        print("user has been signed out")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

