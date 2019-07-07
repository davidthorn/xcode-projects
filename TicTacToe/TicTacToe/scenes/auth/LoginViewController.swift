//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by David Thorn on 06.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseAuth

struct LoginCredentials: Codable {
    let email: String
    let password: String
}

open class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            guard let button = self.loginButton else { return }
            button.isEnabled = false
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let cred = self.credentials else{ fatalError("The credentials must be set for the button to be enabled")}
        Auth.auth().signIn(withEmail: cred.email, password: cred.password) { (result, error) in
            
            guard error == nil else {
                let alert = UIAlertController.init(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
            
            guard let user = result?.user else{ return }
            let vc = GamesListViewController.instance(user: user)
            self.navigationController?.setViewControllers([vc], animated: false)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    var credentials: LoginCredentials! {
        didSet {
            guard let _ = self.credentials else{ return }
            self.loginButton.isEnabled = true
        }
    }
    
    @IBOutlet weak var emailField: UITextField! {
        didSet {
            guard let field = self.emailField else{ return }
            field.text = EMAIL
            field.tag = 0
            field.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!{
        didSet {
            guard let field = self.passwordField else{ return }
            field.tag = 1
            field.text = PASSWORD
            field.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        }
    }
    
    @objc func valueChanged(sender: UITextField) {
        
        let dict = [
            "email" : self.emailField.text,
            "password" : self.passwordField.text
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.credentials = try JSONDecoder.init().decode(LoginCredentials.self, from: data)
        } catch {
            self.credentials = nil
        }
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public static func instance() -> LoginViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return vc
    }
}
