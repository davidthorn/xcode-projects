//
//  ViewController.swift
//  EncryptionApp
//
//  Created by David Thorn on 21.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

import CryptoSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let aes = try! AES(key: "1111111111111111", iv: "1111111111111111")
        let text = try! aes.encrypt(Array("I am a string of text".utf8))
        let dText = try! aes.decrypt(text)
        print(text)
        print(String(bytes: dText , encoding: .utf8))
        print("I am a string of text".utf8)
        
        // Do any additional setup after loading the view.
    }


}

