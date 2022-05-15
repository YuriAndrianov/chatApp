//
//  ChatViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 01.03.2022.
//

import UIKit
import CoreData

final class ConversationsListViewController: BaseChatViewController, IConversationListView {
    
    var presenter: IConversationListPresenter?
    
    private var tableView: UITableView
    private var themePicker: IThemeService
    
    private var currentTheme: ITheme? {
        return themePicker.currentTheme
    }
    
    required override init(themePicker: IThemeService, tableView: UITableView) {
        self.themePicker = themePicker
        self.tableView = tableView
        super.init(themePicker: themePicker, tableView: tableView)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indicatorStyle = currentTheme is NightTheme ? .white : .black
        tableView.backgroundColor = currentTheme?.backgroundColor
        tableView.reloadData() // updates color of table if currentTheme has changed
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.onViewDidAppear()
    }
    
    // MARK: - Setup UI
    
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
        tableView.register(ConversationTableViewCell.nib,
                           forCellReuseIdentifier: ConversationTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    // MARK: - Actions
    
    @objc private func settingsTapped() {
        presenter?.settingsButtonTapped()
    }
    
    @objc private func myProfileTapped() {
        presenter?.myProfileButtonTapped()
    }
    
    @objc private func addChannelTapped() {
        let addChannelAlertVC = UIAlertController(title: "New channel", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let textField = addChannelAlertVC.textFields?.first else { return }
            guard let text = textField.text else { return }
            self?.presenter?.newChannelCreationDidConfirm(with: text)
        }
        confirmAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addChannelAlertVC.addAction(cancelAction)
        addChannelAlertVC.addAction(confirmAction)
        addChannelAlertVC.addTextField { [weak self] field in
            field.placeholder = "Enter channel's name"
            field.addTarget(self, action: #selector(self?.textChanged), for: .editingChanged)
            field.keyboardAppearance = self?.currentTheme?.keyboardAppearance ?? .default
        }
        
        present(addChannelAlertVC, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showAlertDelete(_ channel: DBChannel) {
        let alert = UIAlertController(title: nil,
                                      message: "Are you sure want to delete \"\(channel.name ?? "")\" channel?",
                                      preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.presenter?.channelDeleteDidConfirm(channel)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
        presenter?.channelCellTapped(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] _, _, _ in
            guard let dbChannel = self?.presenter?.getChannelAtIndexPath(indexPath) else { return }
            self?.showAlertDelete(dbChannel)
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
        guard let sections = presenter?.sections else { return 0 }
        return sections[safeIndex: section]?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationTableViewCell.identifier,
            for: indexPath
        ) as? ConversationTableViewCell else { return UITableViewCell() }
        
        guard let dbChannel = presenter?.getChannelAtIndexPath(indexPath) else { return UITableViewCell() }
        cell.configurate(with: Channel(dbChannel: dbChannel))
        return cell
    }
    
}
