//
//  ConversationViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit
import CoreData

final class ConversationViewController: BaseChatViewController, IConversationView {
    
    var presenter: IConversationPresenter?
    
    private var currentTheme: ITheme? {
        return presenter?.themePicker.currentTheme
    }
    
    lazy var containerView: CustomInputView = {
        let view = CustomInputView()
        view.sendButton.isEnabled = false
        view.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.attachButton.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContainerView()
        setupTableView()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.onViewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        title = presenter?.channel.name ?? ""
        view.backgroundColor = currentTheme?.backgroundColor
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
        tableView.register(MessageTableViewCell.nib,
                       forCellReuseIdentifier: MessageTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = currentTheme?.backgroundColor
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - actions
    
    @objc private func sendButtonTapped() {
        presenter?.sendButtonTapped()
    }
    
    @objc private func attachButtonTapped() {
        presenter?.attachButtonTapped()
    }
    
    @objc func tapToDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    func sendPhoto(_ url: String) {
        containerView.textView.text = url
        presenter?.messageText = url
    }
    
    func showNoUserAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "You must have username filled in your profile to send messages",
                                      preferredStyle: .alert)
        
        let goToProfileVCAction = UIAlertAction(title: "Go to \"My profile\"",
                                                style: .default) { [weak self] _ in
            self?.presenter?.sendButtonTappedWithoutUsername()
        }
        
        alert.addAction(goToProfileVCAction)
        
        present(alert, animated: true)
    }
    
    func deleteText() {
        containerView.textView.text = nil
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
    
}

// MARK: - tableview datasource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = presenter?.coreDataManager.messagesFetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        guard let dbMessage = presenter?.coreDataManager.messagesFetchedResultsController.object(at: indexPath),
              let message = Message(dbMessage: dbMessage) else { return UITableViewCell() }
        
        message.senderId == User.userId ? cell.configurateAsOutcoming(with: message) : cell.configurateAsIncoming(with: message)
        
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
        
        presenter?.messageText = result
        textView.text = result
        return false
    }
    
}
