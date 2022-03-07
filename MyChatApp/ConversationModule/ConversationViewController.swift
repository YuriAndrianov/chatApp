//
//  ConversationViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var conversation: Conversation?
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UINib(nibName: "MessageTableViewCell", bundle: .main),
                       forCellReuseIdentifier: MessageTableViewCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private var messages = [[Message]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupMessagesByDate()
        setupUI()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        scrollToBottom()
    }

    private func setupUI() {
        if let conversation = conversation {
            title = conversation.name
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
    }
    
    private func groupMessagesByDate() {
        guard let messages = conversation?.messages else { return }
        
        // force unwrapping dates is safe because messages exist
        let messageDict = Dictionary(grouping: messages) { $0.date!.yearMonthDayOfMessage() }
        
        let sortedKeys = messageDict.keys.sorted { $0 < $1 }
        sortedKeys.forEach {
            let values = messageDict[$0]?.sorted { $0.date! < $1.date! }
            self.messages.append(values ?? [])
        }
    }
    
    private func scrollToBottom() {
        let indexPath = IndexPath(item: 0, section: messages.count - 1)
        tableView.scrollToRow(at: indexPath, at:.bottom, animated: true)
    }

}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let firstMessageInSection = messages[section].first {
            if let messageDate = firstMessageInSection.date {
                if Calendar.current.isDateInToday(messageDate) {
                    return "Today"
                } else {
                    let dateString = firstMessageInSection.date?.lastMessageDateFormat()
                    return dateString
                }
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        let message = messages[indexPath.section][indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
    
}
