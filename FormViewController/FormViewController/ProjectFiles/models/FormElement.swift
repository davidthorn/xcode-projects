//
//  FormElement.swift
//  FormViewController
//
//  Created by David Thorn on 30.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

struct FormElement {
    var id: String
    var label: String
    var name: String
    var value: String?
    var optional: Bool
    var loadCell: (_ item: FormElement , _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    var type: UITableViewCell.Type
}
