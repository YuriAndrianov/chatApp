//
//  ChatViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 01.03.2022.
//

import UIKit
import FirebaseFirestore

final class ConversationsListViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatTableView.backgroundColor = currentTheme?.backgroundColor
        chatTableView.indicatorStyle = currentTheme is NightTheme ? .white : .black
        updateChannels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatTableView.frame = view.bounds
    }
    
    private func setupNavBar() {
        title = "Tinkoff Chat"
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
        
        self.navigationItem.leftBarButtonItem = addChannelButton
        self.navigationItem.rightBarButtonItems = [myProfileButton, settingsButton]
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = currentTheme?.backgroundColor
        view.addSubview(chatTableView)
    }
    
    private func groupChannels() {
        channels = channels.sorted {
            if let lastDate = $0.lastActivity,
            let firstDate = $1.lastActivity {
                return lastDate > firstDate
            } else { return false }
        }
    }
    
    private func createNewChannel(with title: String) {
        let channel = Channel(identifier: "", name: title, lastMessage: nil, lastActivity: Date())
        
        let channelData: [String: Any] = [
            "identifier": channel.identifier as Any,
            "name": channel.name as Any,
            "lastMessage": channel.lastMessage as Any,
            "lastActivity": Timestamp(date: channel.lastActivity ?? Date())
        ]
        
        reference.addDocument(data: channelData)
        updateChannels()
    }
    
    private func updateChannels() {
        channels.removeAll()

        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let self = self else { return }
            
            snapshot?.documents.forEach {
                let data = $0.data()
                
                let identifier = $0.documentID
                let name = data["name"] as? String
                let lastMessage = data["lastMessage"] as? String
                let lastActivity = data["lastActivity"] as? Timestamp

                let channel = Channel(identifier: identifier,
                                      name: name,
                                      lastMessage: lastMessage,
                                      lastActivity: lastActivity?.dateValue())
                self.channels.append(channel)
            }

            self.groupChannels()
            self.chatTableView.reloadData()
        }
    }
    
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
    
    @objc func textChanged(_ sender: UITextField) {
        let field = sender
        var responder: UIResponder? = field
        while !(responder is UIAlertController) { responder = responder?.next }
        let alertVC = responder as? UIAlertController
        alertVC?.actions[1].isEnabled = (field.text != "")
    }

}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let channel = channels[indexPath.row]
        let conversationVC = ConversationViewController()
        conversationVC.channel = channel
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

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Channels"
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
