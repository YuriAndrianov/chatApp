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
    
    private var coreDataManager: ChatObjectsFetchable
    private var firestoreManager: FirestoreManager
    private var channel: Channel?
    private var groupedMessages = [[Message]]()
    private var messages = [Message]()
    
    private var messageText: String? {
        didSet {
            containerView.sendButton.isEnabled = (messageText == "" || messageText == nil) ? false : true
        }
    }
    
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
    
    private lazy var containerView: CustomInputView = {
        let view = CustomInputView()
        view.sendButton.isEnabled = false
        view.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerViewBottomAnchorConstraint: NSLayoutConstraint = {
        return  NSLayoutConstraint(item: containerView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 0)
    }()
       
    init(channel: Channel, coreDataManager: ChatObjectsFetchable) {
        self.channel = channel
        self.coreDataManager = coreDataManager
        
        let firestoreManager = FirestoreManager()
        firestoreManager.channel = channel
        self.firestoreManager = firestoreManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = channel?.name ?? ""
        view.backgroundColor = currentTheme?.backgroundColor
        setupContainerView()
        setupTableView()
        
        guard let id = channel?.identifier else { return }
        coreDataManager.messagePredicate = NSPredicate(format: "channel.identifier == %@", id)
        coreDataManager.messagesFetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerViewBottomAnchorConstraint.constant = -keyboardSize.height
            
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        containerViewBottomAnchorConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupContainerView() {
        containerView.textView.delegate = self
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerViewBottomAnchorConstraint,
            containerView.heightAnchor.constraint(equalToConstant: 65)
        ])
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = currentTheme is NightTheme ? .white : .black
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss(_:))))
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    // MARK: - Fetching messages
    
    private func getMessages() {
        firestoreManager.fetch(.messages) { [weak self] snapshot in
            guard let self = self else { return }
            
            snapshot?.documentChanges.forEach {
                let data = $0.document.data()
                
                guard let snapshotMessage = Message(from: data) else { return }
                
                switch $0.type {
                case .added:
                    self.saveMessageToDB(message: snapshotMessage)
                case .modified:
                    self.updateMessageInDB(message: snapshotMessage)
                case .removed:
                    self.deleteMessageFromDB(message: snapshotMessage)
                }
            }
        }
    }
    
    // MARK: - Handling message changes in coredata
    
    private func saveMessageToDB(message: Message) {
        // checking uniqueness
        let senderId = message.senderId
        let created = message.created
        
        let predicate = NSPredicate(format: "senderId == %@ && created == %@", senderId, created as CVarArg)
        
        guard coreDataManager.fetchMessage(with: predicate) == nil else { return }
        
        let dbMessage = DBMessage(context: coreDataManager.context)
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        
        coreDataManager.saveObject(dbMessage)
        print("Message from \"\(String(describing: message.created))\" saved to DB")
    }
    
    private func updateMessageInDB(message: Message) {
        let senderId = message.senderId
        let created = message.created
        
        let predicate = NSPredicate(format: "senderId == %@ && created == %@", senderId, created as CVarArg)
        
        guard let dbMessage = coreDataManager.fetchMessage(with: predicate) else { return }
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        
        self.coreDataManager.refreshObject(dbMessage)
        
        print("Message from \"\(String(describing: message.created))\" updated in DB")
    }
    
    private func deleteMessageFromDB(message: Message) {
        let senderId = message.senderId
        let created = message.created
        
        let predicate = NSPredicate(format: "senderId == %@ && created == %@", senderId, created as CVarArg)
        
        guard let dbMessage = coreDataManager.fetchMessage(with: predicate) else { return }
        coreDataManager.deleteObject(dbMessage)
        
        print("Message from\"\(String(describing: message.created))\" deleted from DB")
    }
    
    // MARK: - actions
    
    @objc private func sendButtonTapped() {
        guard let messageText = messageText else { return }
        createNewMessage(with: messageText)
        containerView.textView.text = nil
    }
    
    @objc func tapToDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
            self.firestoreManager.addDocument(.messages, data: message.toDict)
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
    
}

// MARK: - tableview datasource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = coreDataManager.messagesFetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else {
                  print("index out of range")
                  return UITableViewCell()
              }
        let dbMessage = coreDataManager.messagesFetchedResultsController.object(at: indexPath)
        
        guard let message = Message(dbMessage: dbMessage) else { return UITableViewCell() }
        
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

extension ConversationViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let resultText = (textView.text ?? "") + text
        
        let result: String
        if range.length == 1 {
            let end = resultText.index(resultText.startIndex, offsetBy: resultText.count - 1)
            result = String(resultText[resultText.startIndex..<end])
        } else { result = resultText }

        messageText = result
        textView.text = result
        return false
    }
    
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
}
