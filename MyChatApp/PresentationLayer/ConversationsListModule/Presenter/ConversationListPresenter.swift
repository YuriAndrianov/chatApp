//
//  ConversationListPresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import Foundation
import CoreData

final class ConversationListPresenter: IConversationListPresenter {
    
    weak var view: IConversationListView?

    var sections: [NSFetchedResultsSectionInfo]? {
        return coreDataManager.channelsFetchedResultsController.sections
    }
    
    private var coreDataManager: IDataBaseService
    private var firestoreManager: FirestoreService
    private var router: IRouter
    
    required init(view: IConversationListView,
                  coreDataManager: IDataBaseService,
                  firestoreManager: FirestoreService,
                  router: IRouter) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.firestoreManager = firestoreManager
        self.router = router
    }
    
    func onViewDidLoad() {
        guard let view = self.view else { return }
        coreDataManager.channelsFetchedResultsController.delegate = view
    }
    
    func onViewDidAppear() {
        fetchChannelsFromFirestore()
    }
    
    func newChannelCreationDidConfirm(with title: String) {
        createNewChannelInFirebase(with: title)
    }
    
    func channelDeleteDidConfirm(_ channel: DBChannel) {
        deleteChannelFromFirebase(channel)
    }
    
    func channelCellTapped(_ indexPath: IndexPath) {
        let dbChannel = coreDataManager.channelsFetchedResultsController.object(at: indexPath)
        let channel = Channel(dbChannel: dbChannel)
        router.showConversation(channel: channel)
    }
    
    func settingsButtonTapped() {
        router.showSettings()
    }
    
    func myProfileButtonTapped() {
        router.showMyProfile()
    }
    
    func getChannelAtIndexPath(_ indexPath: IndexPath) -> DBChannel {
        return coreDataManager.channelsFetchedResultsController.object(at: indexPath)
    }
    
    private func fetchChannelsFromFirestore() {
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
    
    private func createNewChannelInFirebase(with title: String) {
        let channel = Channel(identifier: "", name: title, lastMessage: nil, lastActivity: Date())
        firestoreManager.addDocument(.channels, data: channel.toDict)
    }
    
    private func deleteChannelFromFirebase(_ channel: DBChannel) {
        guard let id = channel.identifier else { return }
        firestoreManager.deleteObject(with: id)
        print("Channel \"\(channel.name ?? "")\" deleted from DB")
    }
    
}
