//
//  Person.swift
//  FirebasePromisesApp
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Promises

public struct Person: Codable {
    public let id: String
    public let name: String
    public let surname: String
    public let age: Int
    public let addressId: String
    public var address: Address?
}

extension Person {
    
    static func get(id: String) -> Person {
        
        var person: Person!
        
        let group = DispatchGroup.init()
        group.enter()
        
        let ref = Database.database().reference(withPath: "people").child(id)
        ref.observe(.value) { (snap) in
            snap.ref.removeAllObservers()
            guard let dict = snap.value as? NSDictionary else { return }
            let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            person = try! JSONDecoder.init().decode(Person.self, from: data)
            group.leave()
        }
        
        group.wait()
        
       return person!
        
    }
    
    static func promise(id: String) -> Promise<Person> {
        
        let p = Promise<Person> { (resolve, reject) in
            
            let ref = Database.database().reference(withPath: "people").child(id)
            ref.observe(.value) { (snap) in
                snap.ref.removeAllObservers()
                guard let dict = snap.value as? NSDictionary else { return }
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var person = try! JSONDecoder.init().decode(Person.self, from: data)
                
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    person.address = try! await(Address.promise(id: person.addressId))
                    resolve(person)
                }
               
            }
            
        }
        
        return p
        
    }
    
}
