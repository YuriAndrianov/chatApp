//
//  ConversationPresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation

final class ConversationPresenter: IConversationPresenter {
    
    weak var view: IConversationView?
    
    var coreDataManager: IDataBaseService
    var firestoreManager: FirestoreManager
    var themePicker: ThemeService
    var router: IRouter
    var channel: Channel
    var messageText: String? {
        didSet {
            view?.containerView.sendButton.isEnabled =
            (messageText == "" || messageText == nil) ?
            false : true
        }
    }
    
    init(
        view: IConversationView,
        coreDataManager: IDataBaseService,
        firestoreManager: FirestoreManager,
        themePicker: ThemeService,
        router: IRouter,
        channel: Channel
    ) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.firestoreManager = firestoreManager
        self.themePicker = themePicker
        self.router = router
        self.channel = channel
    }
    
    func onViewDidLoad() {
        coreDataManager.messagePredicate = NSPredicate(format: "channel.identifier == %@", channel.identifier)
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
        // checking uniqueness
        let predicate = NSPredicate(format: "senderId == %@ && created == %@",
                                    message.senderId,
                                    message.created as CVarArg)
        guard coreDataManager.fetchMessage(with: predicate) == nil else { return }
        
        let dbMessage = DBMessage(context: coreDataManager.context)
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        
        guard let dbChannel = coreDataManager.fetchChannel(with: NSPredicate(format: "identifier == %@",
                                                                             channel.identifier)) else { return }
        dbChannel.addToMessages(dbMessage)
        coreDataManager.saveObject(dbChannel)
        print("Message: \"\(String(describing: message.content))\" saved to DB")
    }
    
    private func updateMessageInDB(message: Message) {
        let predicate = NSPredicate(format: "senderId == %@ && created == %@",
                                    message.senderId,
                                    message.created as CVarArg)
        guard let dbMessage = coreDataManager.fetchMessage(with: predicate) else { return }
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        
        self.coreDataManager.refreshObject(dbMessage)
        print("Message from \"\(String(describing: message.created))\" updated in DB")
    }
    
    private func deleteMessageFromDB(message: Message) {
        let predicate = NSPredicate(format: "senderId == %@ && created == %@",
                                    message.senderId,
                                    message.created as CVarArg)
        guard let dbMessage = coreDataManager.fetchMessage(with: predicate) else { return }
        
        coreDataManager.deleteObject(dbMessage)
        print("Message from\"\(String(describing: message.created))\" deleted from DB")
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
        DataManagerGCD.shared.readFromFile { [weak self] user in
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
    
}
