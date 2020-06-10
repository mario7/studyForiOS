//
//  MessageSampleViewController.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/05/18.
//  Copyright © 2020 snowman. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageSampleViewController: MessagesViewController {
    
    var messageList = [MockMessage]()
    var msgInfos = [String]()
    var currentUserInfo = ("","")
    var sendUserInfo = ("","")
    var picker = UIImagePickerController()
    var fixSentenseTableVc: FixSentenseTableViewController? = nil
    var selectedImage: UIImage?
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
	formatter.timeStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test
        msgInfos = ["notification"]
        currentUserInfo = ("123","deliveryMan")
        sendUserInfo = ("456","Guest")
        
        initMessageCollectionVc()
        initMessageInput()
    }
    
    func initMessageCollectionVc() {
        
        DispatchQueue.main.async {
            // messageListにメッセージの配列をいれて
            self.messageList = self.getMessages()
            // messagesCollectionViewをリロードして
            self.messagesCollectionView.reloadData()
            // 一番下までスクロールする
            self.messagesCollectionView.scrollToBottom()
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor.lightGray
        messageInputBar.sendButton.image = UIImage(named: "send")
        messageInputBar.sendButton.addTarget(self, action: #selector(sendMessage), for: UIControl.Event.touchUpInside)
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        inputMessageWith(messageInputBar, didPressSendButtonWith: "send")
    }
    
    func initMessageInput() {
        // メッセージ入力欄の左に画像選択ボタンを追加
        // 画像選択などなど追加
        let items = [makeImageButton()]
        items.forEach { $0.tintColor = .lightGray }
        messageInputBar.setStackViewItems(items, forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 45, animated: false)
        
        // メッセージ入力時に一番下までスクロール
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
    }
    
    // ボタンの作成
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
        .configure {
                $0.spacing = .fixed(2)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 20, height: 40), animated: true)
        }.onSelected {
            $0.tintColor = UIColor.gray
        }.onDeselected {
            $0.tintColor = UIColor.lightGray
        }
    }
    
    func makeImageButton() -> InputBarButtonItem {
       return makeButton(named: "screenshot")
            .onTextViewDidChange { button, textView in
            button.tintColor = UIColor.lightGray
            button.isEnabled = textView.text.isEmpty
            
        }.onTouchUpInside { [weak self] button in
            //self.inputMessageWith(self.messageInputBar, didPressSendButtonWith: "image")
            self?.showImagePicker()
        }
    }
    
    func makeFixMessageButton() -> InputBarButtonItem {
        makeButton(named: "fix_image")
            .onTextViewDidChange { button, textView in
            button.tintColor = UIColor.lightGray
            button.isEnabled = textView.text.isEmpty
            
        }.onTouchUpInside { [weak self] button in
            //self.inputMessageWith(self.messageInputBar, didPressSendButtonWith: "fix")
            self?.showFixSentenceTableView()
        }
    }
    
    // サンプル用に適当なメッセージ
    func getMessages() -> [MockMessage] {
        msgInfos.map { createMessage(text: $0) }
    }
    
    func createMessage(text: String) -> MockMessage {
        let attributedText = NSAttributedString(string: text,
                                                attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                             .foregroundColor: UIColor.black])
        return MockMessage(attributedText: attributedText,
                           sender: otherSender(),
                           messageId: UUID().uuidString, date: Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showFixSentenceTableView() {
        
        let storyboard = UIStoryboard(name: "Message", bundle: nil)
        guard let tableVc = storyboard.instantiateViewController(withIdentifier: "FixSentenseTableVC") as? FixSentenseTableViewController else {
            return
        }
        fixSentenseTableVc = tableVc
        self.showCustomKeyboardViewDelayed()
        messageInputBar.inputTextView.becomeFirstResponder()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            // your code here
//            self?.showCustomKeyboardViewDelayed()
//        }
        
    }
    
    func showCustomKeyboardViewDelayed() {
        guard let tableVc = fixSentenseTableVc else {
            return
        }
        tableVc.delegate = self
        tableVc.view.translatesAutoresizingMaskIntoConstraints = false
        tableVc.view.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
        //self.present(tableVc, animated: true, completion: nil)
        messageInputBar.inputTextView.inputView = tableVc.view
    }
    
    func showImagePicker() {

        //PhotoLibraryから画像を選択
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //デリゲートを設定する
        picker.delegate = self
        
        //現れるピッカーNavigationBarの文字色を設定する
        picker.navigationBar.tintColor = UIColor.white
        
        //現れるピッカーNavigationBarの背景色を設定する
        picker.navigationBar.barTintColor = UIColor.gray
        
        //ピッカーを表示する
//        present(picker, animated: true, completion: {
//                //self.sendImageMessageIfImageSected()
//            }
//        )
        self.showPickerKeyboardViewDelayed()
        messageInputBar.inputTextView.becomeFirstResponder()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            // your code here
//            self?.showPickerKeyboardViewDelayed()
//        }
        
    }
    
    func showPickerKeyboardViewDelayed() {
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        picker.view.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
        messageInputBar.inputTextView.inputView = picker.view
    }
    
    func  sendImageMessageIfImageSected() -> Bool  {
        guard let image = self.selectedImage else {
            return false
        }
        let imageMessage = MockMessage(image: image, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
        messageList.append(imageMessage)
        messagesCollectionView.insertSections([messageList.count - 1])
        messageInputBar.inputTextView.resignFirstResponder()
        messageInputBar.inputTextView.keyboardType = .default
        return true
    }
}

extension MessageSampleViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(id: currentUserInfo.0, displayName: currentUserInfo.1)
    }
    
    func otherSender() -> Sender {
        return Sender(id: sendUserInfo.0, displayName: sendUserInfo.1)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    // メッセージの上に文字を表示
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                             NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            )
        }
        return nil
    }
    
    // メッセージの上に文字を表示（名前）
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// メッセージのdelegate
extension MessageSampleViewController: MessagesDisplayDelegate {
    
    // メッセージの色を変更（デフォルトは自分：白、相手：黒）
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    // メッセージの背景色を変更している（デフォルトは自分：緑、相手：グレー）
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?
            UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    // メッセージの枠にしっぽを付ける
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    // アイコンをセット
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // message.sender.displayNameとかで送信者の名前を取得できるので
        // そこからイニシャルを生成するとよい
        let avatar = Avatar(initials: "")
        avatarView.set(avatar: avatar)
    }
}


// 各ラベルの高さを設定（デフォルト0なので必須）
extension MessageSampleViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 { return 10 }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension MessageSampleViewController: MessageCellDelegate {
    // メッセージをタップした時の挙動
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
}

extension MessageSampleViewController: MessageInputBarDelegate {
    // メッセージ送信ボタンをタップした時の挙動
    func inputMessageWith(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let components = inputBar.inputTextView.components
        
        for component in components {
            if let image = component as? UIImage {
                
                let imageMessage = MockMessage(image: image, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messageList.append(imageMessage)
                messagesCollectionView.insertSections([messageList.count - 1])
                
            } else if let text = component as? String {
                
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                   .foregroundColor: UIColor.white])
                let message = MockMessage(attributedText: attributedText, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messageList.append(message)
                messagesCollectionView.insertSections([messageList.count - 1])
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
        messageInputBar.inputTextView.resignFirstResponder()
        messageInputBar.inputTextView.keyboardType = .default
    }
}

extension MessageSampleViewController: UIImagePickerControllerDelegate {
    //UIImagePickerControllerのデリゲートメソッド
    
    //画像が選択された時に呼ばれる.
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            
            print("Error")
            return
        }
        
        //ボタンの背景に選択した画像を設定
        //imagePickUpButton.setBackgroundImage(image, for: UIControl.State.normal)
        selectedImage = image
        
        
        // モーダルビューを閉じる
        picker.dismiss(animated: true) {  [weak self]  in
           _ = self?.sendImageMessageIfImageSected()
        }
    }
    
     //画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        picker.dismiss(animated: true, completion: nil)
        messageInputBar.inputTextView.resignFirstResponder()
        messageInputBar.inputTextView.keyboardType = .default
    }
}

extension MessageSampleViewController: UINavigationControllerDelegate {

}

extension MessageSampleViewController: MessageSendProtocol {

    func sendFixMessage(message: String?) {
        guard let message = message else {
            return
        }
        messageInputBar.inputTextView.text = message
        //inputMessageWith(messageInputBar, didPressSendButtonWith: "send")
    }
}
