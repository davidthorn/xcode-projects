//
//  PublicContentViewController.swift
//  FirebaseValidateUserLoggedIn
//
//  Created by David Thorn on 04.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseAuth

class PublicContentViewController: UIViewController {

    @IBAction func loginButton(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: EMAIL, password: PASSWORD) { (result, error) in
            print("user has been signed in")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("view did load")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
