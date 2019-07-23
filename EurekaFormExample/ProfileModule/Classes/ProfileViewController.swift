//
//  ProfileViewController.swift
//  EurekaFormExample
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import ChangeEmailModule
import ChangePasswordModule

open class ProfileViewController: FormViewController {

    public static func load(id: String) -> ProfileInformation {
        let p = ProfileInformation.init(email: "david.tghoe@asAS.D", displayName: nil, photoUrl: nil, uid: id, provider: "Password")
        return p
    }
    
    enum Tags: String {
        case email
        case displayName
        case image
        case changeEmail
        case changePassword
        case deleteAccount
    }
    
    enum Text: String {
        case personalInformation = "Personal Information"
        case email = "Email Address"
        case displayName = "Display Name"
        case optional = "Optional"
        case profileImage = "Profile Image"
        case changeEmail = "Change Current Email"
        case changePassword = "Change Current Password"
        case deleteAccount = "Delete Account"
    }
    
    public struct ProfileInformation: Codable {
        public let email: String
        public let displayName: String?
        public let photoUrl: URL?
        public let uid: String
        public let provider: String
    }
    
    public var information: ProfileInformation!
    
    public static func instance(from url: URL) -> ProfileViewController? {
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let id = comp!.queryItems!.first(where: { $0.name == "id" })!.value!
        let sb = UIStoryboard.init(name: "Profile", bundle: Bundle.init(for: ProfileViewController.self))
        let vc = sb.instantiateInitialViewController() as? ProfileViewController
        do {
            vc?.information = ProfileViewController.load(id: id)
            return vc
        } catch {
            return nil
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(Text.personalInformation.rawValue)
        
            <<< LabelRow.init(Tags.email.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.title = Text.email.rawValue
                    row.value = self.information.email
                })
                
            })
        
            <<< TextRow.init(Tags.displayName.rawValue, { (row) in
                
                row.cellSetup({ (cell, row) in
                    row.value = self.information.displayName
                    row.title = Text.displayName.rawValue
                    row.placeholder = Text.optional.rawValue
                    row.placeholderColor = UIColor.darkGray
                })
                
            })
        
            <<< ImageRow.init(Tags.image.rawValue, { (row) in
                
                var defaultImageLoaded: Bool = false
                
                
                row.cellSetup({ (cell, row) in
                    row.title = Text.profileImage.rawValue
                    row.clearAction = .no
                    self.loadDefaultImage(row: row)
                })
                
                row.onChange({ (row) in
                    if self.information.photoUrl != nil && defaultImageLoaded {
                        row.clearAction = .yes(style: .destructive)
                    } else {
                        defaultImageLoaded = self.information.photoUrl != nil && row.value != nil
                    }
                    guard row.value == nil else { return }
                    defaultImageLoaded = false
                    row.clearAction = .no
                    self.loadDefaultImage(row: row)
                })
                
            })
        
            form +++ Section()
        
                <<< LabelRow.init(Tags.changeEmail.rawValue) { row in
                    row.title = Text.changeEmail.rawValue
                    
                    row.onCellSelection({ (_, _) in
                        let vc = ChangeEmailViewController.instance()
                        self.navigationController?.pushViewController(vc!, animated: true)
                    })
                }
        
                <<< LabelRow.init(Tags.changePassword.rawValue) { row in
                    row.title = Text.changePassword.rawValue
                    
                    row.onCellSelection({ (_, _) in
                        let vc = ChangePasswordViewController.instance()
                        self.navigationController?.pushViewController(vc!, animated: true)
                    })
                    
            }
                <<< ButtonRow.init(Tags.deleteAccount.rawValue, { (row) in
                    row.title = Text.deleteAccount.rawValue
                    row.onCellSelection({ (_, _) in
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                })
        
        // Do any additional setup after loading the view.
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadDefaultImage(row: ImageRow) {
        guard row.value == nil  else { return }
        let a = DispatchQueue.init(label: "asdasd" , attributes: .concurrent)
        a.async {
            guard let url = self.information.photoUrl else { return }
            let data = try! Data.init(contentsOf: url)
            let image = UIImage.init(data: data)
            DispatchQueue.main.async {
                row.value = image
                row.reload()
            }
            
        }
    }
   

}
