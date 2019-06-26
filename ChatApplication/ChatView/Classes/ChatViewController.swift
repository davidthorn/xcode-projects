//
//  ChatViewController.swift
//  ChatView
//
//  Created by David Thorn on 26.06.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

public typealias CellItem = Any

open class ChatViewController: UIViewController {

    internal var delegate: ChatViewDelegateProtocol!
    
    internal var realTimeDatasource: ChatViewRealtimeDatasourceProtocol! {
        didSet {
            guard var realTimeDatasource = self.realTimeDatasource else { return }
            realTimeDatasource.onAdded = { item  in
                /// add the item to the items
                print("message has been added \(item)")
                
                self.tableview.beginUpdates()
                
                self.tableview.insertRows(at: [IndexPath.init(row: self.numberOfRowsInSection, section: 0)], with: .bottom)
                self.items.append(item)
                
                self.tableview.endUpdates()
                
                self.tableview.scrollToRow(at: IndexPath.init(row: self.numberOfRowsInSection - 1, section: 0), at: .bottom, animated: true)
            }
            
            realTimeDatasource.onChanged = { item  in
                /// update the item in the items if exists
            }
            
            realTimeDatasource.onDeleted = { item  in
                // remove item from the items
            }
        }
    }
    
    internal var datasource: ChatViewDatasourceProtocol!
    
    @IBOutlet weak var messageInputField: UITextField! {
        didSet {
            guard let field = self.messageInputField else { return }
            field.placeholder = "Enter your message here"
            field.addTarget(self, action: #selector(messageInputValueChanged), for: .editingChanged)
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            guard let button = self.sendButton else { return }
            button.isEnabled = false
            button.setTitle("Send", for: .normal)
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        self.delegate.sendMessage(text: self.messageInputField.text ?? "") { (error) in
            
            guard error == nil else {
                return self.showError(message: error!)
            }
            
            self.messageInputField.text = nil
           
        }
    }
    
    func showError(message: ChatViewError) {
        print("display error message")
    }
    
    @IBOutlet weak var tableview: UITableView!

    internal var items: [CellItem] = []

    lazy var messagesQueue: DispatchQueue = {
        return DispatchQueue.init(label: "ChatViewController.sync.queue")
    }()
    
    func get(index: IndexPath) -> CellItem {
        return messagesQueue.sync {
            return items[index.row]
        }
    }
    
    internal var numberOfRowsInSection: Int {
        return messagesQueue.sync {
            return items.count
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.datasource.load { (items, realTimeDatasource) in
    
            self.realTimeDatasource = realTimeDatasource
            
            self.messagesQueue.sync {
                self.items = items
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                guard self.items.count > 0 else { return }
                self.tableview.scrollToRow(at: IndexPath.init(row: self.numberOfRowsInSection - 1, section: 0), at: .bottom, animated: true)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

    @objc func messageInputValueChanged(sender: UITextField) {
        let value = sender.text ?? ""
        self.sendButton.isEnabled = value.count > 0
    }
}

extension ChatViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = get(index: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item as? String
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
}

extension ChatViewController: UITableViewDelegate {
 
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableview.frame.width, height: 80))
        return v
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
}
