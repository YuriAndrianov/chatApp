//
//  ConversationViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit
import CoreData
import FirebaseFirestore

final class ConversationViewController: UIViewController {
    
    var coreDataManager: CoreDataManager?
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
    
    init(channel: Channel, coreDataManager: CoreDataManager) {
        self.channel = channel
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        getMessages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchMessagesFromDB()
        }
    }
    
    private func setupUI() {
        title = channel?.name ?? ""
        view.backgroundColor = currentTheme?.backgroundColor
        
        let addMessageButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                               style: .done,
                                               target: self,
                                               action: #selector(addMessageTapped))
        
        navigationItem.rightBarButtonItem = addMessageButton
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
    
    // MARK: - Fetching messages
    
    private func fetchMessagesFromDB() {
        let dbMessages = coreDataManager?.fetchMessages()
        
        dbMessages?.filter { [weak self] in
            $0.channel?.identifier == self?.channel?.identifier
        }.forEach { [weak self] in
            let message = Message(dbMessage: $0)
            self?.addMessageToTable(message)
        }
    }
    
    private func getMessages() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }

            snapshot?.documentChanges.forEach {
                let data = $0.document.data()
                let content = data["content"] as? String ?? ""
                let created = data["created"] as? Timestamp
                let senderId = data["senderID"] as? String ?? ""
                let senderName = data["senderName"] as? String ?? ""
                
                let snapshotMessage = Message(content: content,
                                      created: created?.dateValue() ?? Date(),
                                      senderId: senderId,
                                      senderName: senderName)
                
                switch $0.type {
                case .added:
                    self.addMessageToTable(snapshotMessage)
                    
                    self.coreDataManager?.performSave { context in
                        self.saveMessageToDB(message: snapshotMessage, context: context)
                    }
                case .modified:
                    self.updateMessageInTable(snapshotMessage)
                    
                    self.coreDataManager?.performSave { context in
                        self.updateMessageInDB(message: snapshotMessage, context: context)
                    }
                case .removed:
                    self.removeMessageFromTable(snapshotMessage)
                    
                    self.coreDataManager?.performSave { context in
                        self.removeMessageFromDB(message: snapshotMessage, context: context)
                    }
                }
            }
        }
    }
    
    // MARK: - Handling message changes in coredata
    
    private func saveMessageToDB(message: Message, context: NSManagedObjectContext) {
        let dbMessage = DBMessage(context: context)
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
    }
    
    private func updateMessageInDB(message: Message, context: NSManagedObjectContext) {
        let dbMessage = DBMessage(context: context)
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        
        context.refresh(dbMessage, mergeChanges: true)
    }
    
    private func removeMessageFromDB(message: Message, context: NSManagedObjectContext) {
        let dbMessage = DBMessage(context: context)
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        
        context.delete(dbMessage)
    }
    
    // MARK: - Handling message changes in tableview
    
    private func addMessageToTable(_ message: Message) {
        messages.append(message)
        messages.sort(by: >)
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
    
    // MARK: - actions
    
    @objc func addMessageTapped() {
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
    
    // MARK: - Helpers
    
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
    
    // disables send button if text = ""
    @objc func textChanged(_ sender: UITextField) {
        let field = sender
        var responder: UIResponder? = field
        while !(responder is UIAlertController) { responder = responder?.next }
        let alertVC = responder as? UIAlertController
        alertVC?.actions[1].isEnabled = (field.text != "")
    }
    
}

// MARK: - tableview delegate

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

// MARK: - tableview datasource

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
