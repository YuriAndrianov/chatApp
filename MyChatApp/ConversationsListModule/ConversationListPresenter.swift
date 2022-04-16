//
//  ConversationListPresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import Foundation
import CoreData
import UIKit

protocol ConversationListPresenterProtocol: AnyObject {
    
    var coreDataManager: ChatObjectsFetchable { get set }
    var firestoreManager: FirestoreManager { get set }
    
    init(view: UIViewController,
         coreDataManager: ChatObjectsFetchable,
         firestoreManager: FirestoreManager,
         router: RouterProtocol)
    
    func viewDidAppear()
    
    func newChannelCreationDidConfirm(with title: String)
    
    func channelDeleteDidConfirm(_ channel: DBChannel)
    
    func settingsButtonTapped()
    
    func myProfileButtonTapped()
    
    func channelCellTapped(_ indexPath: IndexPath)
    
}

class ConversationListPresenter: ConversationListPresenterProtocol {
    
    weak var view: UIViewController?

    var coreDataManager: ChatObjectsFetchable
    
    var firestoreManager: FirestoreManager
    
    var router: RouterProtocol
    
    required init(view: UIViewController,
                  coreDataManager: ChatObjectsFetchable,
                  firestoreManager: FirestoreManager,
                  router: RouterProtocol) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.firestoreManager = firestoreManager
        self.router = router
    }
    
    func viewDidAppear() {
        firestoreManager.fetch(.channels) { [weak self] snapshot in
            guard let self = self else { return }
            
            snapshot?.documentChanges.forEach {
                guard let snapshotChannel = Channel(from: $0.document) else { return }
                
                switch $0.type {
                case .added:
                    self.saveChannelToDB(channel: snapshotChannel)
                case .modified:
                    self.updateChannelInDB(channel: snapshotChannel)
                case .removed:
                    self.deleteChannelFromDB(channel: snapshotChannel)
                }
            }
        }
    }
    
    func newChannelCreationDidConfirm(with title: String) {
        let channel = Channel(identifier: "", name: title, lastMessage: nil, lastActivity: Date())
        firestoreManager.addDocument(.channels, data: channel.toDict)
    }
    
    func channelDeleteDidConfirm(_ channel: DBChannel) {
        guard let id = channel.identifier else { return }
        firestoreManager.deleteObject(with: id)
        print("Channel \"\(channel.name ?? "")\" deleted from DB")
    }
    
    func channelCellTapped(_ indexPath: IndexPath) {
        let dbChannel = coreDataManager.channelsFetchedResultsController.object(at: indexPath)
        let channel = Channel(dbChannel: dbChannel)
//        let coreDataManager = DataBaseChatManager(coreDataStack: NewCoreDataStack())
//        let conversationVC = ConversationViewController(channel: channel, coreDataManager: coreDataManager)
//
        router.showConversation(channel: channel)
    }
    
    private func saveChannelToDB(channel: Channel) {
        // checking uniqueness
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        guard coreDataManager.fetchChannel(with: predicate) == nil else { return }
        
        let dbChannel = DBChannel(context: coreDataManager.context)
        dbChannel.identifier = channel.identifier
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        
        coreDataManager.saveObject(dbChannel)
        print("Channel \"\(dbChannel.name ?? "")\" saved to DB")
    }
    
    private func updateChannelInDB(channel: Channel) {
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        guard let dbChannel = coreDataManager.fetchChannel(with: predicate) else { return }
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        coreDataManager.refreshObject(dbChannel)
        print("Channel \"\(dbChannel.name ?? "")\" updated in DB")
    }
    
    private func deleteChannelFromDB(channel: Channel) {
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        guard let dbChannel = coreDataManager.fetchChannel(with: predicate) else { return }
        coreDataManager.deleteObject(dbChannel)
        print("Channel \"\(dbChannel.name ?? "")\" deleted from DB")
    }
    
    func settingsButtonTapped() {
        router.showSettings()
    }
    
    func myProfileButtonTapped() {
        router.showMyProfile()
    }
    
}
