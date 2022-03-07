//
//  ChatViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 01.03.2022.
//

import UIKit

final class ConversationsListViewController: UIViewController {
    
    private let conversations = Mock.conversations
    private var groupedConversations = [[Conversation]]()
    
    private let chatTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UINib(nibName: "ConversationTableViewCell", bundle: .main),
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        groupConversations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatTableView.frame = view.bounds
    }
    
    private func setupNavBar() {
        title = "Tinkoff Chat"
        view.backgroundColor = .systemBackground
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        
        let myProfileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(myProfileTapped))
        
        self.navigationItem.leftBarButtonItem = settingsButton
        self.navigationItem.rightBarButtonItem = myProfileButton
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "navBarBackgroundColor")
        self.navigationController?.navigationBar.tintColor = UIColor(named: "barButtonColor")
        
        // check if current device is iPhone SE (1 gen)
        if UIScreen.main.bounds.width > 375 {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // set custom background color for status bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "navBarBackgroundColor")
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupTableView() {
        view.addSubview(chatTableView)
        chatTableView.delegate = self
        chatTableView.dataSource = self
    }
    
    private func groupConversations() {
        let onlineUserChats = conversations.filter { $0.online }
        let offlineUserChats = conversations.filter { !$0.online }
        
        let onlineUsersWithMessages = onlineUserChats.filter { $0.date != nil }.sorted { $0.date! > $1.date! }
        let onlineUsersWithoutMessages = onlineUserChats.filter { $0.date == nil }
        
        let offlineUserWithMessages = offlineUserChats.filter { $0.date != nil }.sorted { $0.date! > $1.date! }
        let offlineUserWithoutMessages = offlineUserChats.filter { $0.date == nil }
        
        groupedConversations = [onlineUsersWithMessages + onlineUsersWithoutMessages, offlineUserWithMessages + offlineUserWithoutMessages]
        
    }
    
    @objc private func settingsTapped() {
        print("Settings button tapped")
    }
    
    @objc private func myProfileTapped() {
        let profileVC = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileVC)
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversation = groupedConversations[indexPath.section][indexPath.row]
        print(conversation.hasUnreadMessages)
        
        let conversationVC = ConversationViewController()
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedConversations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Online"
        case 1: return "History"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupedConversations[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                           for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        let conversation = groupedConversations[indexPath.section][indexPath.row]
        cell.configurate(with: conversation)
        
        return cell
    }
    
}
