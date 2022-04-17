//
//  ConversationPresenting+ConversationPresentable.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation
import CoreData

protocol ConversationPresenting: AnyObject {
    
    var channel: Channel { get set }
    var coreDataManager: DataBaseService { get set }
    var firestoreManager: FirestoreManager { get set }
    var messageText: String? { get set }
    
    init(view: ConversationPresentable,
         coreDataManager: DataBaseService,
         firestoreManager: FirestoreManager,
         router: Routing,
         channel: Channel)
    
    func viewDidLoad()
    
    func viewDidAppear()
    
    func sendButtonTapped()
    
    func sendButtonTappedWithoutUsername()
    
}

protocol ConversationPresentable: NSFetchedResultsControllerDelegate {
    
    var containerView: CustomInputView { get set }
    
    func showNoUserAlert()
    
}
