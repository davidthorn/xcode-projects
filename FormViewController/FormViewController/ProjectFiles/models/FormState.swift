//
//  FormState.swift
//  FormViewController
//
//  Created by David Thorn on 30.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

struct FormState: Codable {
    var name: String
    var surname: String
    var street: String
    var houseNumber: String
    var postalCode: String
    var town: String
    var state: String?
    var country: String?
}
