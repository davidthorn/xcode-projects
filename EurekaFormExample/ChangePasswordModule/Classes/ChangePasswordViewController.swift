//
//  ChangePasswordViewController.swift
//  EurekaFormExample
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Eureka

open class ChangePasswordViewController: FormViewController {
    
    var passwordData: PasswordData = PasswordData.init(current: nil, password: nil, confirm: nil) {
        didSet {
            let button = self.form.rowBy(tag: Tags.button.rawValue) as! ButtonRow
            let errors = self.form.validate()
            button.disabled = Condition.init(booleanLiteral: !errors.isEmpty)
            button.evaluateDisabled()
        }
    }
    
    struct PasswordData: Codable {
        var current: String?
        var password: String?
        var confirm: String?
    }
    
    enum Tags: String {
        case currentPassword
        case password
        case confPassword
        case button
    }
    
    enum Text: String {
        case personalInformation = "Change Email"
        case currentPassword = "Current Password"
        case password = "New Password"
        case confPassword = "Repeat Password"
        case passwordPlaceholder = "Enter your new password here"
        case currentPasswordPlaceholder = "Enter your current password here"
        case confirmPasswordPlaceholder = "Repeat your new password here"
        case buttonText = "Update"
    }
    
    public static func instance() -> ChangePasswordViewController? {
        let sb = UIStoryboard.init(name: "ChangePassword", bundle: Bundle.init(for: ChangePasswordViewController.self))
        let vc = sb.instantiateInitialViewController() as? ChangePasswordViewController
        return vc
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(Text.personalInformation.rawValue)
            
            <<< PasswordRow.init(Tags.currentPassword.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.add(rule: RuleMinLength.init(minLength: 6))
                    row.add(rule: RuleRequired.init())
                    
                    row.title = Text.currentPassword.rawValue
                    row.placeholder = Text.currentPasswordPlaceholder.rawValue
                })
                
                row.onChange({ (_) in
                    let errors = row.validate()
                    let button = self.form.rowBy(tag: Tags.button.rawValue) as! ButtonRow
                    button.disabled = Condition.init(booleanLiteral: !errors.isEmpty)
                    button.evaluateDisabled()
                    self.passwordData.password = row.value
                })
                
            })
            
            <<< PasswordRow.init(Tags.password.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.add(rule: RuleMinLength.init(minLength: 6))
                    row.add(rule: RuleRequired.init())
                    row.add(rule: RuleEqualsToRow.init(form: self.form, tag: Tags.confPassword.rawValue))
                    row.title = Text.password.rawValue
                    row.placeholder = Text.passwordPlaceholder.rawValue
                })
                
                row.onChange({ (_) in
                   self.passwordData.password = row.value
                })
                
            })
            
            <<< PasswordRow.init(Tags.confPassword.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.add(rule: RuleMinLength.init(minLength: 6))
                    row.add(rule: RuleRequired.init())
                    row.add(rule: RuleEqualsToRow.init(form: self.form, tag: Tags.password.rawValue))
                    row.title = Text.confPassword.rawValue
                    row.placeholder = Text.confirmPasswordPlaceholder.rawValue
                })
                
                row.onChange({ (_) in
                    self.passwordData.confirm = row.value
                })
                
            })
            
            <<< ButtonRow.init(Tags.button.rawValue) { row in
                
                row.cellSetup({ (cell, row) in
                    row.title = Text.buttonText.rawValue
                    row.disabled = true
                    row.evaluateDisabled()
                })
                
                row.onCellSelection({ (_, _) in
                    self.navigationController?.popViewController(animated: true)
                })
        }
    }
    
    
    
}
