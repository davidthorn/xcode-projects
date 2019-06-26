//
//  EmailPasswordLoginViewController.swift
//  EmailPasswordLoginView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

open class EmailPasswordLoginViewController: UIViewController {

    public var minimumNumberOfPasswordCharactersRequired: Int = 6
    
    internal var defaultEmail: String?
    
    @IBOutlet weak var emailFieldLabel: UILabel! {
        didSet {
            guard let label = self.emailFieldLabel else {  return }
            label.text = "Email Address"
        }
    }
    
    @IBOutlet weak var passwordFieldLabel: UILabel!{
        didSet {
            guard let label = self.passwordFieldLabel else {  return }
            label.text = "Password"
        }
    }
    
    @IBOutlet weak var emailField: UITextField! {
        didSet {
            guard let field = self.emailField else {  return }
            field.tag = 0
            field.addTarget(self, action: #selector(textFieldValueChanged), for: UIControl.Event.editingChanged)
            field.placeholder = "Enter you email here"
        }
    }
    
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            guard let field = self.passwordField else {  return }
            field.tag = 1
            field.addTarget(self, action: #selector(textFieldValueChanged), for: UIControl.Event.editingChanged)
            field.placeholder = "Enter you password"
            field.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            guard let button = self.loginButton else {  return }
            button.setTitle("Login", for: .normal)
            button.isEnabled = false
        }
    }

    @IBAction func loginButtonTapped(sender: UIButton) {
        
        let email = self.emailField.text ?? ""
        let password = self.passwordField.text ?? ""
        
        self.delegate.authenticate(email: email, password: password) { (error) in
            
            guard error == nil else {
                return self.showError(error: error!)
            }
            
            self.delegate.shouldContinue(controller: self)
            
        }
        
    }
    
    internal var delegate: EmailPasswordLoginViewDelegateProtocol!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.text = self.defaultEmail
   }

    @objc func textFieldValueChanged(sender: UITextField) {
        let pw = self.passwordField.text ?? ""
        let em = self.emailField.text ?? ""
        
        if pw.count >= self.minimumNumberOfPasswordCharactersRequired && em.count > 0 {
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = false
        }
    }
    
    func showError(error: EmailLoginError) {
        var message: String!
        
        switch error {
        default:
            message = error.rawValue
        }
        
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        
        self.present(alert, animated: true)
        
    }
    
}
