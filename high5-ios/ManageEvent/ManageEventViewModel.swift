//
//  ManageViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 12/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import Foundation

struct ManageEventViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    let userInfo: UserInfoProtocol
    let authManager: AuthProtocol
    
    var userIsLogged: Bool {
        return authManager.userIsLogged
    }
    
    var currentUserUid: String? {
        return authManager.userUid
    }
    
    private func getEvent(eventId: String, completion: @escaping (EventModel?) -> Void) {
        databaseManager.getEvent(eventId: eventId) { eventData in
            guard let createdBy = eventData!["createdBy"] as? String,
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
    
    
    private func getUser(uid: String, completion: @escaping (High5User?) -> Void) {
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
    
    func acceptUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        databaseManager.acceptUser(eventId: eventId, uid: uid) { error in
            completion(error)
        }
    }
    
    func refuseUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        databaseManager.refuseUser(eventId: eventId, uid: uid) { error in
            completion(error)
        }
    }
    
    func kickUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        databaseManager.kickUser(eventId: eventId, uid: uid) { error in
            completion(error)
        }
    }
    
    func getWatingUsers(eventId: String, completion: @escaping ([High5User]) -> Void) {
        var users = [High5User]()

        getEvent(eventId: eventId) { (event) in
            guard event != nil else {
                completion([])
                return
            }
            for (index, element) in (event?.waitingUserIds.enumerated())! {
                self.getUser(uid: element, completion: { user in
                    if (user != nil) {
                        users.append(user!)
                    }
                    if (index >= (event?.waitingUserIds.count)! - 1) {
                        completion(users)
                    }
                })
            }
        }
    }
}
