//
//  Address.swift
//  FirebasePromisesApp
//
//  Created by David Thorn on 07.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation
import Promises
import FirebaseDatabase

public struct Address: Codable {
    public let id: String
    public let houseNumber: Int
    public let street: String
    public let town: String
    public let county : String
    public let country: String
    
    public func save() -> Promise<Address> {
        
        return Promise<Address> { (resolve , reject) in
            let ref = Database.database().reference(withPath: "address").child(self.id)
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            
            ref.setValue(data, withCompletionBlock: { (error, _) in
                
                guard error == nil  else {
                    return reject(error!)
                }
                
                resolve(self)
                
            })
        }
        
        
        
    }
    
}

extension Address {
    
    static func get(id: String) -> Address {
        
        var address: Address!
        
        let group = DispatchGroup.init()
        group.enter()
        
        let ref = Database.database().reference(withPath: "address").child(id)
        ref.observe(.value) { (snap) in
            snap.ref.removeAllObservers()
            guard let dict = snap.value as? NSDictionary else { return }
            let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            address = try! JSONDecoder.init().decode(Address.self, from: data)
            group.leave()
        }
        
        group.wait()
        
        return address!
        
    }
    
    static func promise(id: String) -> Promise<Address> {
        
        let p = Promise<Address> { (resolve, reject) in
            
            let ref = Database.database().reference(withPath: "address").child(id)
            ref.observe(.value) { (snap) in
                snap.ref.removeAllObservers()
                guard let dict = snap.value as? NSDictionary else { return }
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let address = try! JSONDecoder.init().decode(Address.self, from: data)
                resolve(address)
            }
            
        }
        
        return p
        
    }
    
}
