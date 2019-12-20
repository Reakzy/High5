//
//   GroupChatViewContoller.swift
//  high5
//
//  Created by Arnaud Costa on 28/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit
//
class HeadlineChatTableViewCell: UITableViewCell {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
}

class HeadlineChatTableViewOtherCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var sayByName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var picture: UIImageView!
}

class ChatViewController: UIViewController {
    
    //@IBOutlet private weak var bottomNewMassage: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newMassage: UITextField!
    var eventId = String()
    var groupName = String()
    private var messages = [MessageModel]()
    let viewModel = ChatViewModel(databaseManager: FirebaseDatabaseManager(), userInfo: UserInfoFirebase(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = groupName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        newMassage.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Details",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(details))
        if !viewModel.userIsLogged {
            navigationController?.popToRootViewController(animated: true)
        }
        viewModel.getMessage(eventId: eventId, completion: { [weak self] msg in
            guard let msg = msg else {
                return
            }
            
            self?.messages = msg
            self?.tableView.reloadData()
            self?.tableView.scrollToBottom()
        })
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func details() {
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as! EventDetailsViewController
        newVC.eventId_ = eventId
        newVC.btnTitle_ = "CHAT"
        navigationController?.show(newVC, sender: nil)
    }
    
//    @objc func keyboardWillShow(notification : Notification) {
//        if notification.userInfo != nil {
//            self.view.layoutIfNeeded()
//
//            UIView.animate(withDuration: 0.25, animations: {
//                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                    let keyboardRectangle = keyboardFrame.cgRectValue
//                    self.bottomNewMassage.constant = keyboardRectangle.height
//                }
//            })
//        }
//    }
//
//    @objc func keyboardWillHide(notification : Notification) {
//        if notification.userInfo != nil {
//            self.view.layoutIfNeeded()
//
//            UIView.animate(withDuration: 0.25, animations: {
//                self.bottomNewMassage.constant = 0
//            })
//        }
//    }

}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        
        if ((viewModel.currentUser?.block) != nil) {
            if ((viewModel.currentUser?.block!.contains(message.createdBy))!) {
                navigationController?.popViewController(animated: true)
                self.navigationController?.displayError(message: "Ce groupe contient une ou des personne(s) que vous avez bloqué.")
            }
        }
        
        if (viewModel.currentUserUid == message.createdBy) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ownerMessageCell", for: indexPath) as! HeadlineChatTableViewCell
            cell.message?.text = message.content
            cell.message.layer.masksToBounds = true
            cell.message.layer.cornerRadius = 8;
            cell.date.text = message.createdAt
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherMessageCell", for: indexPath) as! HeadlineChatTableViewOtherCell
        viewModel.getUser(uid: message.createdBy) { (user) in
            if user?.name == nil {
                cell.sayByName.text = "Unknown"
            }
            else {
                cell.sayByName.text = user?.name
            }
            cell.message?.text = message.content
            cell.date.text = message.createdAt
            cell.message.layer.masksToBounds = true
            cell.message.layer.cornerRadius = 8;
            self.viewModel.getImage(user?.profilPicture ?? "", cell.picture)
            cell.picture.layer.cornerRadius = cell.picture.frame.size.width / 2
            cell.picture.clipsToBounds = true
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        guard messages[didSelectRowAt.row].id != "", messages[didSelectRowAt.row].createdBy != viewModel.currentUser?.id else {
            return
        }
        let alertViewController = UIAlertController(title: "Bloquer l'utilisateur",
                                                    message: "Attention en bloquent cette utilisateur vous n'aurais plus accès à cette t'en que l'utilisateur y est present.",
                                                    preferredStyle: .alert)

        let reportAction = UIAlertAction(title: "Bloquer l'utilisateur", style: .default, handler:
        { action in
            self.viewModel.blockUser(uid: self.viewModel.currentUserUid!, blockUid: self.messages[didSelectRowAt.row].createdBy, completion: { (error) in
                return
            })
        })
        
        let backAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
        alertViewController.addAction(reportAction)
        alertViewController.addAction(backAction)
        present(alertViewController, animated: true)
    }
}

extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        newMassage.resignFirstResponder()
        let newMassageText = newMassage.text
        guard newMassageText != nil,
        newMassageText != "" else {
            return false
        }
        if (!viewModel.addMessage(eventId: eventId, msg: newMassageText!)) {
            textField.text = ""
            displayError(message: "Votre message n'a pas pu être envoyé.")
        }
        textField.text = ""
        return true
    }
}
