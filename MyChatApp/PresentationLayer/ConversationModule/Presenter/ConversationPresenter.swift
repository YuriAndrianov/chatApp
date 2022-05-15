//
//  ConversationPresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation
import CoreData

final class ConversationPresenter: IConversationPresenter {
    
    weak var view: IConversationView?
    
    var sections: [NSFetchedResultsSectionInfo]? {
        return coreDataManager.messagesFetchedResultsController.sections
    }
    
    var channel: Channel
    var messageText: String? {
        didSet {
            (messageText == "" || messageText == nil) ?
            view?.enableSendButton(false) :  view?.enableSendButton(true)
        }
    }
    
    private var coreDataManager: IDataBaseService
    private var firestoreManager: FirestoreService
    private var router: IRouter
    private var dataService: IDataService
    
    init(
        view: IConversationView,
        coreDataManager: IDataBaseService,
        firestoreManager: FirestoreService,
        dataService: IDataService,
        router: IRouter,
        channel: Channel
    ) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.firestoreManager = firestoreManager
        self.dataService = dataService
        self.router = router
        self.channel = channel
    }
    
    func onViewDidLoad() {
        coreDataManager.setPredicate(with: channel)
        guard let view = self.view else { return }
        coreDataManager.messagesFetchedResultsController.delegate = view
    }
    
    func onViewDidAppear() {
        fetchMessagesFromFirestore()
    }
    
    func sendButtonTapped() {
        guard let messageText = messageText else { return }
        createNewMessage(with: messageText)
        deleteText()
    }
    
    func attachButtonTapped() {
        router.showNetworkPicker()
    }
    
    func sendButtonTappedWithoutUsername() {
        router.showMyProfile()
    }
    
    private func deleteText() {
        self.messageText = nil
        view?.deleteText()
    }
    
    private func saveMessageToDB(message: Message) {
        coreDataManager.addMessage(message, to: channel)
    }
    
    private func updateMessageInDB(message: Message) {
        coreDataManager.updateMessage(message)
    }
    
    private func deleteMessageFromDB(message: Message) {
        coreDataManager.deleteMessage(message)
    }
    
    private func fetchMessagesFromFirestore() {
        firestoreManager.fetch(.messages) { [weak self] snapshot in
            guard let self = self else { return }
            
            snapshot?.documentChanges.forEach {
                let data = $0.document.data()
                
                guard let snapshotMessage = Message(from: data) else { return }
                
                switch $0.type {
                case .added:
                    self.saveMessageToDB(message: snapshotMessage)
                case .modified:
                    self.updateMessageInDB(message: snapshotMessage)
                case .removed:
                    self.deleteMessageFromDB(message: snapshotMessage)
                }
            }
        }
    }
    
    private func createNewMessage(with text: String) {
        dataService.readFromFile { [weak self] user in
            guard let self = self else { return }
            guard
                let user = user,
                let userName = user.fullname,
                userName != "" else {
                    self.view?.showNoUserAlert()
                    return
                }
            
            let message = Message(content: text,
                                  created: Date(),
                                  senderId: User.userId,
                                  senderName: user.fullname ?? "")
            self.firestoreManager.addDocument(.messages, data: message.toDict)
        }
    }
    
    func getMessageAtIndexPath(_ indexPath: IndexPath) -> DBMessage {
        return coreDataManager.messagesFetchedResultsController.object(at: indexPath)
    }
    
}
