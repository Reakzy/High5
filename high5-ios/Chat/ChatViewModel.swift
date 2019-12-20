//
//  ChatViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 29/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

struct ChatViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    let userInfo: UserInfoProtocol
    let authManager: AuthProtocol
    
    var userIsLogged: Bool {
        return userInfo.currentUser != nil
    }
    
    var currentUser: High5User? {
        return userInfo.currentUser
    }
    
    var currentUserUid: String? {
        return authManager.userUid
    }
    
    var userPhotoUrl: String? {
        return userInfo.userPhotoUrl
    }
    
    func getMessage(eventId: String, completion: @escaping ([MessageModel]?) -> Void) {
        databaseManager.getMessages(eventId: eventId, completion: { arrayId, arrayData in
            var i = 0
            let messages = arrayData.compactMap({ (data) -> MessageModel? in
                guard let id = arrayId[i],
                    let createdBy = data!["createdBy"] as? String,
                    var createdAt = data!["createdAt"] as? String,
                    let content = data!["content"] as? String,
                    let eventId = data!["eventId"] as? String else {
                        i += 1
                        return nil
                }
                i += 1
                createdAt = String().dateToString(date: Date().stringToDate(date: createdAt, format: "MM-dd-yyyy HH:mm"), format: "MM-dd-yyyy HH:mm")
                return MessageModel(id: id, createdBy: createdBy, createdAt: createdAt, content: content, eventId : eventId)
            })
            completion(messages)
        })
    }
    
    func addMessage(eventId: String, msg: String) -> Bool {
        if currentUserUid == nil {
            return false
        }
        databaseManager.createMessage(eventId: eventId, userUid: currentUserUid!, content: msg)
        return true
    }
    
    func getUser(uid: String, completion: @escaping (High5User?) -> Void) {
        databaseManager.getUser(uid: uid) { user in
            guard user != nil else {
                completion(nil)
                return
            }
            guard let email = user!["email"] as? String,
                let photoUrl = user!["profilePicture"] as? String,
                let age = user!["birthdayDate"] as? String,
                let name = user!["fullName"] as? String else {
                    completion(nil)
                    return
            }
            var block = user!["block"] as? [String]
            if (block == nil) {
                block = []
            }
            completion(High5User(id: uid, email : email, profilPicture : photoUrl, birthdayDate: age, name : name, block: block))
        }
    }
    
    func getImage(_ url_str:String, _ imageView: UIImageView) {
        if (url_str != "") {
            let url:URL = URL(string: url_str)!
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                if data != nil {
                    let image = UIImage(data: data!)
                    
                    if (image != nil) {
                        DispatchQueue.main.async(execute: {
                            imageView.image = image
                            imageView.alpha = 0
                            UIView.animate(withDuration: 0, animations: {
                                imageView.alpha = 1.0
                            })
                        })
                    }
                }
            })
            task.resume()
        }
    }
    
    func blockUser(uid: String, blockUid: String, completion: @escaping (Bool) -> Void) {
        databaseManager.blockUser(uid: uid, blockUid: blockUid) { (error) in
            completion(error)
        }
    }
    
}
