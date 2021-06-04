//
//  MessageViewController.swift
//  Messenger
//
//  Created by Леонид on 31.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var messages: [MMessage] = []
    
    var currentUser: MUser?
    var chat: MChat?
    
    override func viewDidLoad() {
        navigationBar.title = chat?.username
        navigationBar.backBarButtonItem?.title = "Back"
        
        self.becomeFirstResponder()
        
        messagesCollectionView.backgroundColor = .white
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        super.viewDidLoad()
    }
    
    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
}

extension MessageViewController: MessagesDataSource {
    public func currentSender() -> SenderType {
        return Sender(senderId: currentUser!.id, displayName: currentUser!.username)
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    
}

extension MessageViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .purple
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

extension MessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: currentUser!, content: text)
        insertNewMessage(message: message)
        inputBar.inputTextView.text = ""
    }
}
