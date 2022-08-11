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
    private var firestoreManager: IFirestoreService
    private var router: IRouter
    
    required init(view: IConversationListView,
                  coreDataManager: IDataBaseService,
                  firestoreManager: IFirestoreService,
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
        coreDataManager.saveChannel(channel)
    }
    
    private func updateChannelInDB(channel: Channel) {
        coreDataManager.updateChannel(channel)
    }
    
    private func deleteChannelFromDB(channel: Channel) {
        coreDataManager.deleteChannel(channel)
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
