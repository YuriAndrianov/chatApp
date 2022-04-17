//
//  ChatViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 01.03.2022.
//

import UIKit
import CoreData

final class ConversationsListViewController: UIViewController, ConversationListPresentable {
    
    var presenter: ConversationListPresenting?

    private var currentTheme: Theme? {
        return ThemePicker.shared.currentTheme
    }
    
    private lazy var chatTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = currentTheme?.backgroundColor
        table.register(ConversationTableViewCell.nib,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        presenter?.viewDidLoad()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
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
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = currentTheme?.backgroundColor
        view.addSubview(chatTableView)
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
            field.addTarget(self, action: #selector(self?.textChanged(_:)), for: .editingChanged)
            field.keyboardAppearance = self?.currentTheme is NightTheme ? .dark : .default
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let dbChannel = self?.presenter?
                    .coreDataManager
                    .channelsFetchedResultsController.object(at: indexPath) else { return }
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
        guard let sections = presenter?.coreDataManager.channelsFetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                           for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        guard let dbChannel = presenter?
                .coreDataManager
                .channelsFetchedResultsController.object(at: indexPath) else { return UITableViewCell() }
        let channel = Channel(dbChannel: dbChannel)
        cell.configurate(with: channel)
        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

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
