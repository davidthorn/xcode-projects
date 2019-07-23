//
//  ChangeEmailViewController.swift
//  EurekaFormExample
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Eureka

open class ChangeEmailViewController: FormViewController {
    
    enum Tags: String {
        case email
        case button
    }
    
    enum Text: String {
        case title = "Change Email Address"
        case personalInformation = "Change Email"
        case email = "Email Address"
        case displayName = "Display Name"
        case optional = "Optional"
        case profileImage = "Profile Image"
        case save = "Update Email Address"
        case emailPlaceholder = "Enter your new email address here"
    }
    
    public static func instance() -> ChangeEmailViewController? {
        let sb = UIStoryboard.init(name: "ChangeEmail", bundle: Bundle.init(for: ChangeEmailViewController.self))
        let vc = sb.instantiateInitialViewController() as? ChangeEmailViewController
        return vc
    }
    
    var newEmail: String?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Text.title.rawValue
        form +++ Section(Text.personalInformation.rawValue)
            
            <<< EmailRow.init(Tags.email.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.add(rule: RuleEmail.init())
                    row.add(rule: RuleRequired.init())
                    row.title = Text.email.rawValue
                    row.placeholder = Text.emailPlaceholder.rawValue
                })
                
                row.onChange({ (_) in
                    let errors = row.validate()
                    let button = self.form.rowBy(tag: Tags.button.rawValue) as! ButtonRow
                    button.disabled = Condition.init(booleanLiteral: !errors.isEmpty)
                    button.evaluateDisabled()
                    self.newEmail = row.value
                })
                
            })
        
            <<< ButtonRow.init(Tags.button.rawValue) { row in
                
                row.cellSetup({ (cell, row) in
                    row.title = Text.save.rawValue
                })
                
                row.onCellSelection({ (_, _) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
    }
    
}
