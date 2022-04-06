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
    var firestoreManager: FirestoreManager?
    var channel: Channel?
    
    private var groupedMessages = [[Message]]()
    private var messages = [Message]()
    
    private var currentTheme: ThemeProtocol? {
        return ThemePicker.shared.currentTheme
    }

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
        self.firestoreManager = FirestoreManager(channel: channel)
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
            guard let message = Message(dbMessage: $0) else { return }
            self?.addMessageToTable(message)
        }
    }
    
    private func getMessages() {
        firestoreManager?.fetch(.messages) { [weak self] snapshot in
            guard let self = self else { return }
            
            snapshot?.documentChanges.forEach {
                let data = $0.document.data()
                
                guard let snapshotMessage = Message(from: data) else { return }
                
                switch $0.type {
                case .added:
                    self.addMessageToTable(snapshotMessage)
                    self.coreDataManager?.performSave { context in
                        self.saveMessageToDB(message: snapshotMessage, context: context)
                    }
                case .modified:
                    self.updateMessageInTable(snapshotMessage)
                    self.updateMessageInDB(message: snapshotMessage)
                    
                case .removed:
                    self.removeMessageFromTable(snapshotMessage)
                    self.deleteMessageFromDB(message: snapshotMessage)
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
    
    private func updateMessageInDB(message: Message) {
        guard let dbMessage = self.coreDataManager?.fetchMessageWithPredicate(message: message) else { return }
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        
        self.coreDataManager?.refreshObject(dbMessage)
    }
    
    private func deleteMessageFromDB(message: Message) {
        guard let dbMessage = self.coreDataManager?.fetchMessageWithPredicate(message: message) else { return }
        self.coreDataManager?.deleteObject(dbMessage)
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
        tableView.reloadData()
    }
    
    private func removeMessageFromTable(_ message: Message) {
        guard let index = messages.firstIndex(of: message) else { return }
        messages.remove(at: index)
        tableView.reloadData()
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
            guard
                let user = user,
                let userName = user.fullname,
                userName != "" else {
                    self.showNoUserAlert()
                    return
                }

                let message = Message(content: text,
                                      created: Date(),
                                      senderId: User.userId,
                                      senderName: user.fullname ?? "")
            self.firestoreManager?.addDocument(.messages, data: message.toDict)
        }
    }
    
    private func showNoUserAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "You must have your username filled in your profile to send messages",
                                      preferredStyle: .alert)
        
        let goToProfileVCAction = UIAlertAction(title: "Go to \"My profile\"",
                                                style: .default) { [weak self] _ in
            let profileVC = ProfileViewController()
            let navigationController = CustomNavigationController(rootViewController: profileVC)
            self?.present(navigationController, animated: true, completion: nil)
        }
        
        alert.addAction(goToProfileVCAction)
        
        present(alert, animated: true)
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

// MARK: - tableview datasource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = messages[indexPath.row, default: Message(content: "default",
                                                               created: Date(),
                                                               senderId: "",
                                                               senderName: "default name")]
        if message.senderId == User.userId {
            cell.configurateAsOutcoming(with: message)
        } else {
            cell.configurateAsIncoming(with: message)
        }
        
        cell.selectionStyle = .none
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
}

// MARK: - tableview delegate

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
