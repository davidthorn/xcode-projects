//
//  ViewController.swift
//  FormViewController
//
//  Created by David Thorn on 30.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var formState: FormState? {
        let dict = self.elements.reduce([:]) { (dict, item) -> NSDictionary in
            let _dict = NSMutableDictionary.init(dictionary: dict)
            if item.type == InputRowCell.self {
                _dict[item.name] = item.value
            }
            return _dict
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return try JSONDecoder.init().decode(FormState.self, from: data)
        } catch {
            return nil
        }
    }
    
    /// Indicates if all fields that are required have been filled out
    var formCompleted: Bool {
        return formState != nil
    }
    
    var elements: [FormElement] = [] {
        didSet {
            /// enable / disable the form button if visible based upon if the form has been filled out correctly
            let cell = tableView.visibleCells.first{ $0 is FormButtonCellTableViewCell }.map{ $0 as! FormButtonCellTableViewCell }
            cell?.button.isEnabled = formCompleted
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form View Controller"
        
        self.elements = [
            .init(id: "1", label: "Name", name: "name", value: nil, optional: false, loadCell: self.loadFormCell , type: InputRowCell.self ),
            .init(id: "2", label: "Surname", name: "surname", value: nil, optional: false, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "3", label: "Street", name: "street", value: nil, optional: false, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "4", label: "House Number", name: "houseNumber", value: nil, optional: false, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "5", label: "Postal Code", name: "postalCode", value: nil, optional: false, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "6", label: "Town", name: "town", value: nil, optional: false, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "7", label: "State", name: "state", value: nil, optional: true, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "8", label: "Country", name: "country", value: nil, optional: true, loadCell: self.loadFormCell, type: InputRowCell.self),
            .init(id: "9", label: "", name: "button", value: nil, optional: true, loadCell: self.loadButtonCell, type: FormButtonCellTableViewCell.self)
        ]
        
        self.tableView.register(InputRowCell.nib, forCellReuseIdentifier: InputRowCell.reuseIdentifier)
        self.tableView.register(FormHeaderView.nib, forHeaderFooterViewReuseIdentifier: FormHeaderView.reuseIdentifier)
        self.tableView.register(FormButtonCellTableViewCell.nib, forCellReuseIdentifier: FormButtonCellTableViewCell.reuseIdentifier)
    }

    /// Loads a Form Cell for this index path
    ///
    /// - Parameters:
    ///   - item: FormElement
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    func loadFormCell(_ item: FormElement, _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InputRowCell.reuseIdentifier, for: indexPath) as! InputRowCell
        cell.element = item
        cell.inputField.inputAccessoryView = nil
        cell.inputFieldLabel.text = item.label
        cell.inputField.delegate = self
        cell.inputField.tag = indexPath.row
        cell.inputField.addTarget(self, action: #selector(textFieldValueChanged), for: UIControl.Event.editingChanged)
        cell.inputField.returnKeyType = indexPath.row == elements.count - 2 ? .done : .next
        return cell
    }
    
    /// Loads a button cell for this index path
    ///
    /// - Parameters:
    ///   - item: FormElement
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    func loadButtonCell(_ item: FormElement, _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormButtonCellTableViewCell.reuseIdentifier, for: indexPath) as! FormButtonCellTableViewCell
        cell.element = item
        cell.button.addTarget(self, action: #selector(formButtonTapped), for: UIControl.Event.touchUpInside)
        cell.button.isEnabled = self.formCompleted
        return cell
    }
    
    /// Called when the form button has been tapped
    ///
    /// - Parameter sender: UIButton
    @objc func formButtonTapped(sender: UIButton) {
        print("button was tapped")
        let state = self.formState!
        let fullName = "\(state.name) \(state.surname)"
        let address = "\(state.houseNumber) \(state.street)\n\(state.postalCode) \(state.town)"
        
        let alert = UIAlertController.init(title: "Success", message: "Thank you for submitting your details \(fullName).\nYour package will be sent to \n\(address)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        self.present(alert, animated: true)
        
    }
    
    /// Creates the tableview cell for this index path
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.elements[indexPath.row]
        return item.loadCell(item , tableView , indexPath)
    }
    
    /// Delegate method that is called every time the text fields value has changed
    ///
    /// - Parameter sender: UITextField
    @objc func textFieldValueChanged(sender: UITextField) {
        let v = sender.text ?? ""
        self.elements[sender.tag].value = v.count == 0 ? nil : v
    }
    
    /// Returns the number of sections that this form should display
    ///
    /// - Parameter tableView: UITableView
    /// - Returns: Int
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FormHeaderView.reuseIdentifier) as! FormHeaderView
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        let v = textField.text ?? ""
        self.elements[tag].value = v.count == 0 ? nil : v
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: tag + 1, section: 0)) as? InputRowCell else {
            self.view.endEditing(true);
            return
        }
        cell.inputField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: tag + 1, section: 0)) as? InputRowCell else {
            self.view.endEditing(true)
            return false }
        cell.inputField.becomeFirstResponder()
        return true
    }
    
}
