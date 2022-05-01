//
//  IConversationListPresenter+IConversationListView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation
import CoreData

protocol IConversationListPresenter: AnyObject {
    
    var coreDataManager: IDataBaseService { get }
    var firestoreManager: FirestoreService { get }
    var themePicker: ThemeService { get }
    
    init(view: IConversationListView,
         coreDataManager: IDataBaseService,
         firestoreManager: FirestoreService,
         themePicker: ThemeService,
         router: IRouter)
    
    func onViewDidLoad()
    
    func onViewDidAppear()
    
    func newChannelCreationDidConfirm(with title: String)
    
    func channelDeleteDidConfirm(_ channel: DBChannel)
    
    func settingsButtonTapped()
    
    func myProfileButtonTapped()
    
    func channelCellTapped(_ indexPath: IndexPath)
    
}

protocol IConversationListView: NSFetchedResultsControllerDelegate {}
