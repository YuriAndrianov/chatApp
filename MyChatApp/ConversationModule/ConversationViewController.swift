//
//  ConversationViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit

final class ConversationViewController: UIViewController {
    
    var conversation: Conversation?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MessageTableViewCell.nib,
                       forCellReuseIdentifier: MessageTableViewCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = ThemePicker.currentTheme?.backGroundColor
        table.transform = CGAffineTransform(rotationAngle: -.pi)
        return table
    }()
    
    private var messages = [[Message]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupMessagesByDate()
        setupUI()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setupUI() {
        if let conversation = conversation {
            title = conversation.name
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func groupMessagesByDate() {
        guard let messages = conversation?.messages else { return }

        // grouping messages by dates in YYMMDD format
        let messageDict = Dictionary(grouping: messages) { $0.date?.yearMonthDayOfMessage() }
        
        // sorting keys (dates) by >
        let sortedKeys = messageDict.keys.sorted { lastDate, firstDate in
            if let lastDate = lastDate,
               let firstDate = firstDate {
                return lastDate > firstDate
            } else { return false }
        }
        
        // creating values (messages)
        sortedKeys.forEach {
            // sorting values (messages) by dates
            let values = messageDict[$0]?.sorted {
                if let lastDate = $0.date,
                   let firstDate = $1.date {
                    return lastDate > firstDate
                } else { return false }
            }
            self.messages.append(values ?? [])
        }
    }

}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let firstMessageInSection = messages[section].first,
              let messageDate = firstMessageInSection.date else { return nil }
        
        return Calendar.current.isDateInToday(messageDate) ? "Today" : firstMessageInSection.date?.lastMessageDateFormat()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier,
                                                       for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        let message = messages[indexPath.section][indexPath.row]
        cell.configure(with: message)
        cell.selectionStyle = .none
        cell.transform = CGAffineTransform(rotationAngle: -.pi)
        return cell
    }
    
}

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.transform = CGAffineTransform(rotationAngle: -.pi)
        footer.textLabel?.textColor = ThemePicker.currentTheme?.fontColor
        
        if #available(iOS 14.0, *) {
            footer.backgroundConfiguration?.backgroundColor = ThemePicker.currentTheme?.backGroundColor
        } else {
            footer.backgroundColor = ThemePicker.currentTheme?.backGroundColor
        }
    }
    
}
