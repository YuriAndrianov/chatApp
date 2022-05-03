//
//  IConversationPresenter+IConversationView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation
import CoreData

protocol IConversationPresenter: AnyObject {
    
    var channel: Channel { get set }
    var messageText: String? { get set }
    var sections: [NSFetchedResultsSectionInfo]? { get }
    
    init(view: IConversationView,
         coreDataManager: IDataBaseService,
         firestoreManager: FirestoreManager,
         router: IRouter,
         channel: Channel)
    
    func onViewDidLoad()
    
    func onViewDidAppear()
    
    func sendButtonTapped()
    
    func attachButtonTapped()
    
    func sendButtonTappedWithoutUsername()
    
    func getMessageAtIndexPath(_ indexPath: IndexPath) -> DBMessage
    
}

protocol IConversationView: NSFetchedResultsControllerDelegate {
    
    var containerView: CustomInputView { get set }
    
    func showNoUserAlert()
    
    func deleteText()
    
    func sendPhoto(_ url: String)
    
    func enableSendButton(_ bool: Bool)
    
}
