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
        getMessages()
    }
    
    private func setupUI() {
        title = channel?.name ?? ""
        view.backgroundColor = currentTheme?.backgroundColor
        
        let addMessageButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                               style: .done,
                                               target: self,
                                               action: #selector(showAddMessageAlertVC))
        
        navigationItem.rightBarButtonItem = addMessageButton
    }
    
    @objc func showAddMessageAlertVC() {
        let addChannelAlertVC = UIAlertController(title: "New message", message: nil, preferredStyle: .alert)
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let textField = addChannelAlertVC.textFields?.first else { return }
            guard let text = textField.text else { return }
            self?.createNewMessage(with: text)
        }
        sendAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addChannelAlertVC.addAction(cancelAction)
        addChannelAlertVC.addAction(sendAction)
        addChannelAlertVC.addTextField { [weak self] field in
            field.placeholder = "Start typing here..."
            field.addTarget(self, action: #selector(self?.textChanged(_:)), for: .editingChanged)
            field.keyboardAppearance = self?.currentTheme is NightTheme ? .dark : .default
        }
        
        present(addChannelAlertVC, animated: true)
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
    
    private func getMessages() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let self = self else { return }
            
            snapshot?.documentChanges.forEach {
                let data = $0.document.data()
                let content = data["content"] as? String ?? ""
                let created = data["created"] as? Timestamp
                let senderId = data["senderID"] as? String ?? ""
                let senderName = data["senderName"] as? String ?? ""
                
                let message = Message(content: content,
                                      created: created?.dateValue() ?? Date(),
                                      senderId: senderId,
                                      senderName: senderName)
                
                switch $0.type {
                case .added: self.addMessageToTable(message)
                case .modified: self.updateMessageInTable(message)
                case .removed: self.removeMessageFromTable(message)
                default: break
                }
            }
        }
    }
    
    private func addMessageToTable(_ message: Message) {
        messages.append(message)
        messages = messages.sorted { $0.created > $1.created }
        tableView.reloadData()
    }
    
    private func updateMessageInTable(_ message: Message) {
        guard let index = messages.firstIndex(of: message) else { return }
        messages[index] = message
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeMessageFromTable(_ message: Message) {
        guard let index = messages.firstIndex(of: message) else { return }
        messages.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func createNewMessage(with text: String) {
        DataManagerGCD.shared.readFromFile { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                let message = Message(content: text,
                                      created: Date(),
                                      senderId: User.userId,
                                      senderName: user.fullname ?? "")
                self.reference.addDocument(data: message.toDict)
            }
        }
    }
    
    @objc func textChanged(_ sender: UITextField) {
        let field = sender
        var responder: UIResponder? = field
        while !(responder is UIAlertController) { responder = responder?.next }
        let alertVC = responder as? UIAlertController
        alertVC?.actions[1].isEnabled = (field.text != "")
    }
    
}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = messages[indexPath.row]
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
