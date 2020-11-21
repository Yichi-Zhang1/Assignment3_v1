//
//  QAChattingViewController.swift
//  Assignment3
//
//  Created by Danny on 2020-11-21.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    
}

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    
}

struct Media: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    
}

class QAChattingViewController: MessagesViewController {
    
    
    
    @IBAction func tapBtn(_ sender: Any) {
        
    }
    let selfSender = Sender(senderId: UUID().uuidString, displayName: "Me")
    let chatbot = Sender(senderId: UUID().uuidString, displayName: "Chatbot")
    
    var networkController: NetworkController?
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        
        networkController = NetworkController(listener: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func insertMessage(_ message: Message) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
         
         guard !messages.isEmpty else { return false }
         
         let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
         
         return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
     }
}
extension QAChattingViewController: MessagesDisplayDelegate, MessagesDataSource,MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
extension QAChattingViewController: NetworkListener{
    func onRequest() {
        
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        if response != nil && (response as! QAResponse).answerText != nil {
            let res = response as! QAResponse
            insertMessage(Message(sender: chatbot, messageId: UUID().uuidString, sentDate: Date(), kind: .text(res.answerText!)))
            if res.media != nil {
                for m in res.media! {
                    insertMessage(Message(sender: chatbot, messageId: UUID().uuidString, sentDate: Date(), kind: .text(m.title!)))
                }
            }
        } else {
            insertMessage(Message(sender: chatbot, messageId: UUID().uuidString, sentDate: Date(), kind: .text("Due to the network issues, I cannot answer you.")))
        }
    }
    
    
}

extension QAChattingViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        insertMessage(Message(sender: selfSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text)))
        networkController?.findQuickAnswer(query: text)
        inputBar.inputTextView.text = String()
    }
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == selfSender.senderId {
            avatarView.image = UIImage(named: "me")!
        } else {
            avatarView.image = UIImage(named: "chatbot")!
        }
    }
}
