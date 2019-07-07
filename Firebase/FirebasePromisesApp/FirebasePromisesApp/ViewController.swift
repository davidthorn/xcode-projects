//
//  ViewController.swift
//  FirebasePromisesApp
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Promises

class ViewController: UIViewController {

    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.background.async {
           
//            let id = Database.database().reference().childByAutoId().key!
//            let address = Address(id: id, houseNumber: 2, street: "Test Street", town: "Test Town", county: "Test County", country: "Test country").save()
//
//            let remoteAddress = try! await(address)
//
//
            //let person = Person.get(id: "-LjDMvL3obYpRf5D8AuG")
            let pPerson: Person = try! await(Person.promise(id: "-LjDMvL3obYpRf5D8AuG"))
            
            print(pPerson)
            
        }
    
    }


    
}

