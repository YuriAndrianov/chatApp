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
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = ThemePicker.shared.currentTheme?.backGroundColor
        table.register(ConversationTableViewCell.nib,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private var isLargeScreenDevice: Bool {
        // check if current device is not iPhone SE (1 gen)
        return UIScreen.main.bounds.width > 375
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        groupConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatTableView.reloadData()
        chatTableView.backgroundColor = ThemePicker.shared.currentTheme?.backGroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatTableView.frame = view.bounds
    }
    
    private func setupNavBar() {
        title = "Tinkoff Chat"
        view.backgroundColor = ThemePicker.shared.currentTheme?.backGroundColor
        
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
        self.navigationController?.navigationBar.prefersLargeTitles = isLargeScreenDevice
    }
    
    private func setupTableView() {
        chatTableView.backgroundColor = ThemePicker.shared.currentTheme?.backGroundColor
        view.addSubview(chatTableView)
        chatTableView.delegate = self
        chatTableView.dataSource = self
    }
    
    private func groupConversations() {
        let onlineUserChats = conversations.filter { $0.online }
        let offlineUserChats = conversations.filter { !$0.online }
        
        let onlineUsersWithMessages = onlineUserChats.filter { $0.date != nil }.sorted {
            if let lastDate = $0.date,
               let firstDate = $1.date {
                return lastDate > firstDate
            } else { return false }
        }
        
        let onlineUsersWithoutMessages = onlineUserChats.filter { $0.date == nil }
        
        let offlineUserWithMessages = offlineUserChats.filter { $0.date != nil }.sorted {
            if let lastDate = $0.date,
               let firstDate = $1.date {
                return lastDate > firstDate
            } else { return false }
        }
        
        let offlineUserWithoutMessages = offlineUserChats.filter { $0.date == nil }
        
        groupedConversations = [onlineUsersWithMessages + onlineUsersWithoutMessages, offlineUserWithMessages + offlineUserWithoutMessages]
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

}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversation = groupedConversations[indexPath.section][indexPath.row]
        
        let conversationVC = ConversationViewController()
        conversationVC.conversation = conversation
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = ThemePicker.shared.currentTheme?.fontColor
        
        if #available(iOS 14.0, *) {
            header.backgroundConfiguration?.backgroundColor = ThemePicker.shared.currentTheme?.backGroundColor
        } else {
            header.backgroundColor = ThemePicker.shared.currentTheme?.backGroundColor
        }
    }
    
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedConversations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Online"
        case 1: return "History"
        default: return nil
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
