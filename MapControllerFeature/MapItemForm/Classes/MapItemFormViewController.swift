//
//  MapItemFormViewController.swift
//  MapItemForm
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

open class MapItemFormViewController: FormViewController {

    enum Tags: String {
        case name
        case description
    }
    
    enum Text: String {
        case itemDescriptionHeader = "Give your item a informative description"
        case description = "Item description goes here"
        case nameLabel = "Item Name"
        case namePlaceholder = "Enter your item name"
        case descriptionPlaceholder = "Enter your description here"
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Map Item Basic Informaiton")
        
            <<< TextRow.init(Tags.name.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.placeholder = Text.namePlaceholder.rawValue
                    row.title = Text.nameLabel.rawValue
                })
                
            })
        
        
        
        form +++ Section(Text.itemDescriptionHeader.rawValue)
            
            <<< TextAreaRow.init(Tags.description.rawValue, { (row) in
                row.textAreaHeight = TextAreaHeight.fixed(cellHeight: 200)
                row.cellSetup({ (cell, row) in
                    row.placeholder = Text.descriptionPlaceholder.rawValue
                })
                
            })
        
        form +++ Section.init("Map Item Banner Image")
        
        
            <<< ImageRow.init("banner", { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.title = "Add banner image"
                    row.clearAction = .no
                    row.add(rule: RuleRequired.init())
                })
                
                row.onChange({ (row) in
                    
                    switch row.value {
                    case nil:
                        row.clearAction = .no
                    default:
                        row.clearAction = .yes(style: .destructive)
                    }
                    
                })
                
            })
        
            form +++ Section.init("Visibility")
            
            <<< SwitchRow.init("enabled", { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.title = "Is Visible for others"
                    row.value = false
                    
                })
                
                row.onChange({ (row) in
                    
                    let value = row.value ?? false
                    
                    switch value {
                    case true:
                        print("is enabled")
                    case false:
                        print("is not enabled")
                    }
                    
                })
                
            })
        
        form +++ Section.init()
            
            <<< ButtonRow.init("button", { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.title = "Save"
                    row.disabled = true
                })
                
                row.onCellSelection({ (cell, row) in
                    print("button has been pressed")
                    self.navigationController?.popViewController(animated: true)
                })
                
            })
        
        // Do any additional setup after loading the view.
    }
    

 
}
