//
//  EventViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 21/01/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

struct EventDetailsViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    let userInfo: UserInfoProtocol
    let authManager: AuthProtocol
    
    var userIsLogged: Bool {
        return authManager.userIsLogged
    }
    
    var currentUserUid: String? {
        return authManager.userUid
    }
    
    var userDisplayName: String? {
        return userInfo.userDisplayName
    }
    
    var userPhotoUrl: String? {
        return userInfo.userPhotoUrl
    }
    
    func getEvent(eventId: String, completion: @escaping (EventModel?) -> Void) {
        databaseManager.getEvent(eventId: eventId) { eventData in
            guard eventData != nil,
                let createdBy = eventData!["createdBy"] as? String,
                let createdAt = eventData!["createdAt"] as? String,
                let updatedAt = eventData!["updatedAt"] as? String,
                let eventAt = eventData!["eventAt"] as? String,
                let name = eventData!["name"] as? String,
                let place = eventData!["place"] as? String,
                let description = eventData!["description"] as? String,
                let userIds = eventData!["userIds"] as? [String],
                let waitingUserIds = eventData!["waitingUserIds"] as? [String],
                let groupePicture = eventData!["groupePicture"] as? String,
                let userMaxNumber = eventData!["userMaxNumber"] as? NSNumber else {
                    completion(nil)
                    return
            }
            completion(EventModel(id: eventId, createdBy: createdBy, createdAt: createdAt, updatedAt: updatedAt, eventAt: eventAt, name: name, place: place, description: description, userIds: userIds, waitingUserIds: waitingUserIds, groupePicture: groupePicture, userMaxNumber: userMaxNumber))
        }
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
    
    func deletEvent(eventId: String, completion: @escaping (Bool) -> Void) {
        databaseManager.deletEvent(eventId: eventId) { error in
            completion(error)
            return
        }
    }
    
    func joinEvent(eventId: String, uid : String, completion: @escaping (Bool) -> Void) {
        databaseManager.joinEvent(eventId: eventId, uid : uid) { error in
            completion(error)
            return
        }
    }
    
    func leaveEvent(eventId: String, uid : String, completion: @escaping (Bool) -> Void) {
        databaseManager.leaveEvent(eventId: eventId, uid : uid) { error in
            completion(error)
            return
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
    
}
