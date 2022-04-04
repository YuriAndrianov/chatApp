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
    
    var coreDataManager: CoreDataManager?
    
    private var currentTheme: ThemeProtocol? {
        return ThemePicker.shared.currentTheme
    }
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    private lazy var chatTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = currentTheme?.backgroundColor
        table.register(ConversationTableViewCell.nib,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private var channels = [Channel]()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        getChannels()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchChannelsFromDB()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatTableView.backgroundColor = currentTheme?.backgroundColor
        chatTableView.indicatorStyle = currentTheme is NightTheme ? .white : .black
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
        let dbChannels = coreDataManager?.fetchChannels()
        dbChannels?.forEach { [weak self] in
            let channel = Channel(dbChannel: $0)
            self?.addChannelToTable(channel)
        }
    }
    
    private func getChannels() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }

            snapshot?.documentChanges.forEach {
                let data = $0.document.data()
                
                let identifier = $0.document.documentID
                let name = data["name"] as? String ?? ""
                let lastMessage = data["lastMessage"] as? String
                let lastActivity = data["lastActivity"] as? Timestamp
                
                let snapshotChannel = Channel(identifier: identifier,
                                      name: name,
                                      lastMessage: lastMessage,
                                      lastActivity: lastActivity?.dateValue())
                
                switch $0.type {
                case .added:
                    self.addChannelToTable(snapshotChannel)

                    self.coreDataManager?.performSave { context in
                        self.saveChannelToDB(channel: snapshotChannel, context: context)
                    }
                case .modified:
                    self.updateChannelInTable(snapshotChannel)
                    
                    self.coreDataManager?.performSave { context in
                        self.updateChannelInDB(channel: snapshotChannel, context: context)
                    }
                case .removed:
                    self.updateChannelInTable(snapshotChannel)
                    
                    self.coreDataManager?.performSave { context in
                        self.removeChannelFromDB(channel: snapshotChannel, context: context)
                    }
                }
            }
        }
    }
    
    // MARK: - Handling channel changes in coredata
    
    private func saveChannelToDB(channel: Channel, context: NSManagedObjectContext) {
        let dbChannel = DBChannel(context: context)
        dbChannel.identifier = channel.identifier
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        print("Channel \"\(channel.name)\" saved to DB")
    }
    
    private func updateChannelInDB(channel: Channel, context: NSManagedObjectContext) {
        let dbChannel = DBChannel(context: context)
        dbChannel.identifier = channel.identifier
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        
        context.refresh(dbChannel, mergeChanges: true)
        print("Channel \"\(channel.name)\" updated in DB")
    }
    
    private func removeChannelFromDB(channel: Channel, context: NSManagedObjectContext) {
        let dbChannel = DBChannel(context: context)
        dbChannel.identifier = channel.identifier
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        
        context.delete(dbChannel)
        print("Channel \"\(channel.name)\" deleted from DB")
    }
    
    // MARK: - Handling channel changes in tableview
    
    private func addChannelToTable(_ channel: Channel) {
        if channels.contains(channel) { return }
        channels.append(channel)
        sortChannelsByDate()
        chatTableView.reloadData()
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        chatTableView.reloadData()
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        chatTableView.reloadData()
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
        reference.addDocument(data: channel.toDict)
    }
    
    // disables confirm button if text = ""
    @objc func textChanged(_ sender: UITextField) {
        let field = sender
        var responder: UIResponder? = field
        while !(responder is UIAlertController) { responder = responder?.next }
        let alertVC = responder as? UIAlertController
        alertVC?.actions[1].isEnabled = (field.text != "")
    }
    
}

// MARK: - tableview delegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let channel = channels[indexPath.row]
        let coreDataManager = NewCoreDataManager()
        
        let conversationVC = ConversationViewController(channel: channel, coreDataManager: coreDataManager)
        
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = currentTheme?.fontColor
        
        if #available(iOS 14.0, *) {
            header.backgroundConfiguration?.backgroundColor = currentTheme?.backgroundColor
        } else {
            header.backgroundColor = currentTheme?.backgroundColor
        }
    }

}

// MARK: - tableview datasource

extension ConversationsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                           for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        let channel = channels[indexPath.row]
        cell.configurate(with: channel)
        return cell
    }
    
}
