//
//  ConversationViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit

class ConversationViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        
        return table
    }()
    
    var messages: [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Messages"
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}
