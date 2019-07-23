//
//  ViewController.swift
//  EurekaFormExample
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Eureka
import ProfileModule

class ViewController: FormViewController {

    struct TempState: Codable {
        var email: String?
        var password: String?
    }
    
    struct Credentials: Codable {
        let email: String
        let password: String
        struct ProfileInformation: Codable {
            let email: String
            let displayName: String?
            let photoUrl: URL?
            let uid: String
            let provider: String
        }
        func information() -> Data {
            let info = ProfileInformation.init(email: self.email, displayName: nil, photoUrl: URL(string: "https://picsum.photos/200/300"), uid: UUID.init().uuidString, provider: "Password")
            return try! JSONEncoder.init().encode(info)
        }
    }
    
    var credentials: Credentials? {
        didSet {
            guard let button = form.rowBy(tag: "button") as? ButtonRow else { return }
            button.disabled = Condition.init(booleanLiteral: self.credentials == nil)
            button.evaluateDisabled()
        }
    }
    
    var state: TempState = TempState(email: nil, password: nil) {
        didSet {
            let errors = form.validate()
            
            let email = self.state.email ?? ""
            let password = self.state.password ?? ""
            let enabled = errors.isEmpty
            self.credentials = enabled ? Credentials.init(email: email, password: password) : nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Login Information") 
            
            <<< EmailRow("email", { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.add(rule: RuleEmail.init(msg: "This is not a valid email ", id: "asdasd"))
                    row.add(rule: RuleRequired.init())
                    row.title = "Email"
                    row.placeholder = "Enter your email address"
                    row.validationOptions = .validatesAlways
                })
                
                row.onChange({ (row) in
                    self.state.email = row.value
                })
            })
        
            <<< PasswordRow("password", { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.add(rule: RuleRequired.init(msg: "The password is required", id: "password-required-id"))
                    row.add(rule: RuleMinLength.init(minLength: 6))
                    row.title = "Password"
                    row.placeholder = "Enter your password here"
                })
                
                
                row.onChange({ (row) in
                    self.state.password = row.value
                })
                
            })
        
            <<< ButtonRow("button", { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.title = "Login"
                    row.disabled = Condition.init(booleanLiteral: true)
                    row.evaluateDisabled()
                })
                
                row.onCellSelection({ (cell, row) in
                    guard !row.isDisabled else { return }
                    print("button tapped")
                    UIApplication.shared.open(URL(string: "auth://profile?id=asdasd")!, options: [:], completionHandler: { (d) in
                        print("did open \(d)")
                    })
                    
                })
                
            })
        
            form +++ Section.init()
            
            <<< LabelRow("forgottenPassword") { row in
                row.cellSetup({ (cell, row) in
                    cell.textLabel?.textAlignment = .center
                    row.title = "Forgot your password"
                })
                
                row.onCellSelection({ (_, _) in
                    
                    let email = self.form.rowBy(tag: "email") as! EmailRow
                    let errors = email.validate()
                    
                    if errors.isEmpty {
                        print("confirm email has been sent to email address")
                    } else {
                        print("require user to enter their email")
                    }
                })
            }
    }


}

