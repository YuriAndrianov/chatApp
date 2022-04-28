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
    var coreDataManager: IDataBaseService { get }
    var firestoreManager: FirestoreManager { get }
    var themePicker: ThemeService { get }
    var messageText: String? { get set }
    
    init(view: IConversationView,
         coreDataManager: IDataBaseService,
         firestoreManager: FirestoreManager,
         themePicker: ThemeService,
         router: IRouter,
         channel: Channel)
    
    func onViewDidLoad()
    
    func onViewDidAppear()
    
    func sendButtonTapped()
    
    func attachButtonTapped()
    
    func sendButtonTappedWithoutUsername()
    
}

protocol IConversationView: NSFetchedResultsControllerDelegate {
    
    var containerView: CustomInputView { get set }
    
    func showNoUserAlert()
    
    func deleteText()
    
    func sendPhoto(_ url: String)
    
}
