//
//  ChatViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 01.03.2022.
//

import UIKit
import CoreData
import FirebaseFirestore

final class ConversationsListViewController: UIViewController {
    
    private var coreDataManager: ChatObjectsFetchable
    private var firestoreManager: FirestoreManager
    
    private var currentTheme: ThemeProtocol? {
        return ThemePicker.shared.currentTheme
    }
    
    private lazy var chatTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = currentTheme?.backgroundColor
        table.register(ConversationTableViewCell.nib,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private var channels = [Channel]()
    
    init(coreDataManager: ChatObjectsFetchable, firestoreManager: FirestoreManager) {
        self.coreDataManager = coreDataManager
        self.firestoreManager = firestoreManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        //        getChannels()
        
        coreDataManager.channelsFetchedResultsController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatTableView.backgroundColor = currentTheme?.backgroundColor
        chatTableView.indicatorStyle = currentTheme is NightTheme ? .white : .black
        fetchChannelsFromDB()
        chatTableView.reloadData() // updates color of table if currentTheme has changed
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatTableView.frame = view.bounds
    }
    
    private func setupNavBar() {
        title = "Channels"
        view.backgroundColor = currentTheme?.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        let myProfileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(myProfileTapped))
        let addChannelButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                               style: .done,
                                               target: self,
                                               action: #selector(addChannelTapped))
        
        self.navigationItem.rightBarButtonItem = addChannelButton
        self.navigationItem.leftBarButtonItems = [myProfileButton, settingsButton]
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = currentTheme?.backgroundColor
        view.addSubview(chatTableView)
    }
    
    // MARK: - Fetching channels
    
    private func fetchChannelsFromDB() {
        coreDataManager.fetchChannels(with: nil)
    }
    
    private func getChannels() {
        firestoreManager.fetch(.channels) { [weak self] snapshot in
            guard let self = self else { return }
            
            snapshot?.documentChanges.forEach {
                guard let snapshotChannel = Channel(from: $0.document) else { return }
                
                switch $0.type {
                case .added:
                    self.coreDataManager.coreDataStack.performSave { context in
                        self.saveChannelToDB(channel: snapshotChannel, context: context)
                    }
                case .modified:
                    self.updateChannelInDB(channel: snapshotChannel)
                case .removed:
                    self.deleteChannelFromDB(channel: snapshotChannel)
                }
            }
        }
    }
    
    // MARK: - Handling channel changes in coredata
    
    private func saveChannelToDB(channel: Channel, context: NSManagedObjectContext) {
        // checking uniqueness
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        coreDataManager.fetchChannels(with: predicate)
        guard coreDataManager.channelsFetchedResultsController?.fetchedObjects?.first == nil else { return }
        
        let dbChannel = DBChannel(context: context)
        dbChannel.identifier = channel.identifier
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        print("Channel \"\(String(describing: channel.name))\" saved to DB")
    }
    
    private func updateChannelInDB(channel: Channel) {
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        coreDataManager.fetchChannels(with: predicate)
        guard let dbChannel = coreDataManager.channelsFetchedResultsController?.fetchedObjects?.first else { return }
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        
        self.coreDataManager.coreDataStack.refreshObject(dbChannel)
        print("Channel \"\(String(describing: dbChannel.name))\" updated in DB")
    }
    
    private func deleteChannelFromDB(channel: Channel) {
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        coreDataManager.fetchChannels(with: predicate)
        guard let dbChannel = coreDataManager.channelsFetchedResultsController?.fetchedObjects?.first else { return }
        self.coreDataManager.coreDataStack.deleteObject(dbChannel)
        print("Channel \"\(String(describing: dbChannel.name))\" deleted from DB")
    }
    
    // MARK: - Actions
    
    @objc private func settingsTapped() {
        let themesVC = ThemesViewController()
        navigationController?.pushViewController(themesVC, animated: true)
    }
    
    @objc private func myProfileTapped() {
        let profileVC = ProfileViewController()
        let navigationController = CustomNavigationController(rootViewController: profileVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func addChannelTapped() {
        let addChannelAlertVC = UIAlertController(title: "New channel", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let textField = addChannelAlertVC.textFields?.first else { return }
            guard let text = textField.text else { return }
            self?.createNewChannel(with: text)
        }
        confirmAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addChannelAlertVC.addAction(cancelAction)
        addChannelAlertVC.addAction(confirmAction)
        addChannelAlertVC.addTextField { [weak self] field in
            field.placeholder = "Enter channel's name"
            field.addTarget(self, action: #selector(self?.textChanged(_:)), for: .editingChanged)
            field.keyboardAppearance = self?.currentTheme is NightTheme ? .dark : .default
        }
        
        present(addChannelAlertVC, animated: true)
    }
    
    // MARK: - Helpers
    
    private func sortChannelsByDate() {
        channels = channels.sorted {
            if let lastDate = $0.lastActivity,
               let firstDate = $1.lastActivity {
                return lastDate > firstDate
            } else { return false }
        }
    }
    
    private func createNewChannel(with title: String) {
        let channel = Channel(identifier: "", name: title, lastMessage: nil, lastActivity: Date())
        firestoreManager.addDocument(.channels, data: channel.toDict)
    }
    
    // disables confirm button if text = ""
    @objc func textChanged(_ sender: UITextField) {
        let field = sender
        var responder: UIResponder? = field
        while !(responder is UIAlertController) { responder = responder?.next }
        
        let alertVC = responder as? UIAlertController
        
        guard let action = alertVC?.actions[safeIndex: 1] else { return }
        action.isEnabled = (field.text != "")
    }
    
}

// MARK: - tableview delegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let dbChannel = coreDataManager.channelsFetchedResultsController?.object(at: indexPath) else { return }
        let channel = Channel(dbChannel: dbChannel)
        
        let coreDataManager = NewCoreDataManager()
        let conversationVC = ConversationViewController(channel: channel, coreDataManager: coreDataManager)
        
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let dbChannel = self?.coreDataManager.channelsFetchedResultsController?.object(at: indexPath) else { return }
            self?.coreDataManager.coreDataStack.deleteObject(dbChannel)
            self?.fetchChannelsFromDB()
            print("Channel \"\(String(describing: dbChannel.name))\" deleted from DB")
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

// MARK: - tableview datasource

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreDataManager.channelsFetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                           for: indexPath) as? ConversationTableViewCell,
              let dbChannel = coreDataManager.channelsFetchedResultsController?.object(at: indexPath) else { return UITableViewCell() }
        
        let channel = Channel(dbChannel: dbChannel)
        
        cell.configurate(with: channel)
        return cell
    }
    
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            chatTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            chatTableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            chatTableView.deleteRows(at: [indexPath], with: .automatic)
            chatTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            chatTableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
}
