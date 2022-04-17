//
//  ConversationListPresenting+ConversationListPresentable.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation
import CoreData

protocol ConversationListPresenting: AnyObject {
    
    var coreDataManager: DataBaseService { get set }
    var firestoreManager: FirestoreService { get set }
    
    init(view: ConversationListPresentable,
         coreDataManager: DataBaseService,
         firestoreManager: FirestoreService,
         router: Routing)
    
    func viewDidLoad()
    
    func viewDidAppear()
    
    func newChannelCreationDidConfirm(with title: String)
    
    func channelDeleteDidConfirm(_ channel: DBChannel)
    
    func settingsButtonTapped()
    
    func myProfileButtonTapped()
    
    func channelCellTapped(_ indexPath: IndexPath)
    
}

protocol ConversationListPresentable: NSFetchedResultsControllerDelegate {}
