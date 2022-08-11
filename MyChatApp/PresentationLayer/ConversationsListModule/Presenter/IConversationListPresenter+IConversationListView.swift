//
//  IConversationListPresenter+IConversationListView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation
import CoreData

protocol IConversationListPresenter: AnyObject {
    
    var sections: [NSFetchedResultsSectionInfo]? { get }
    
    init(view: IConversationListView,
         coreDataManager: IDataBaseService,
         firestoreManager: IFirestoreService,
         router: IRouter)
    
    func onViewDidLoad()
    func onViewDidAppear()
    func newChannelCreationDidConfirm(with title: String)
    func channelDeleteDidConfirm(_ channel: DBChannel)
    func settingsButtonTapped()
    func myProfileButtonTapped()
    func channelCellTapped(_ indexPath: IndexPath)
    func getChannelAtIndexPath(_ indexPath: IndexPath) -> DBChannel
}

protocol IConversationListView: NSFetchedResultsControllerDelegate {}
