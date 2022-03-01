//
//  ChatViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 01.03.2022.
//

import UIKit

class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        title = "Chat"
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = navBarBackgroundColor
        self.navigationController?.navigationBar.tintColor = barButtonItemsColor
        
        // set custom background color for status bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = navBarBackgroundColor
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc func settingsTapped() {
        print("Settings button tapped")
    }
    
    @objc func myProfileTapped() {
        let profileVC = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileVC)
        present(navigationController, animated: true, completion: nil)
    }
    
}
