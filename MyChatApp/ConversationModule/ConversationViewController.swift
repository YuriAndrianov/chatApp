//
//  ConversationViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit
import FirebaseFirestore

final class ConversationViewController: UIViewController {
    
    var channel: Channel?
    
    private var groupedMessages = [[Message]]()
    private var messages = [Message]()
    
    private var currentTheme: ThemeProtocol? {
        return ThemePicker.shared.currentTheme
    }
    
    private lazy var db = Firestore.firestore()
    
    private lazy var reference: CollectionReference = {
        let id = channel?.identifier ?? ""
        return db.collection("channels").document(id).collection("messages")
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MessageTableViewCell.nib,
                       forCellReuseIdentifier: MessageTableViewCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = currentTheme?.backgroundColor
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        updateMessages()
    }
  
    private func setupUI() {
        title = channel?.name ?? ""
        view.backgroundColor = currentTheme?.backgroundColor
        
        let addMessageButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                               style: .done,
                                               target: self,
                                               action: #selector(addMessage))
        
        navigationItem.rightBarButtonItem = addMessageButton
    }
    
    @objc func addMessage() {
        let message: [String: Any] = [
            "content": "Test message",
            "created": Timestamp(date: Date()),
            "senderID": 12345,
            "senderName": "John Smith"
        ]
        
        reference.addDocument(data: message)
        updateMessages()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = currentTheme is NightTheme ? .white : .black
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    private func updateMessages() {
        messages.removeAll()
        
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let self = self else { return }
            
            snapshot?.documents.forEach {
                let data = $0.data()
                
                let content = data["content"] as? String
                let created = data["created"] as? Timestamp
                let senderId = data["senderId"] as? String
                let senderName = data["senderName"] as? String
                
                let message = Message(content: content,
                                      created: created?.dateValue(),
                                      senderId: senderId,
                                      senderName: senderName)
                self.messages.append(message)
            }
            
            self.groupMessagesByDate()
            self.tableView.reloadData()
        }
    }
    
    private func groupMessagesByDate() {
        // grouping messages by dates in YYMMDD format
        let messageDict = Dictionary(grouping: messages) { $0.created?.yearMonthDayOfMessage() }
        
        // sorting keys (dates) by >
        let sortedKeys = messageDict.keys.sorted { lastDate, firstDate in
            if let lastDate = lastDate,
               let firstDate = firstDate {
                return lastDate > firstDate
            } else { return false }
        }
        
        // creating values (messages)
        sortedKeys.forEach {
            // sorting values (messages) by dates
            let values = messageDict[$0]?.sorted {
                if let lastDate = $0.created,
                   let firstDate = $1.created {
                    return lastDate > firstDate
                } else { return false }
            }
            groupedMessages.append(values ?? [])
        }
    }
}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessages[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedMessages.count
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let firstMessageInSection = groupedMessages[section].first,
              let messageDate = firstMessageInSection.created else { return nil }
        
        return Calendar.current.isDateInToday(messageDate) ? "Today" : firstMessageInSection.created?.lastMessageDateFormat()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = groupedMessages[indexPath.section][indexPath.row]
        cell.configurate(with: message)
        cell.selectionStyle = .none
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
}

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.transform = CGAffineTransform(scaleX: 1, y: -1)
        footer.textLabel?.textColor = currentTheme?.fontColor
        
        if #available(iOS 14.0, *) {
            footer.backgroundConfiguration?.backgroundColor = currentTheme?.backgroundColor
        } else {
            footer.backgroundColor = currentTheme?.backgroundColor
        }
    }
    
}
