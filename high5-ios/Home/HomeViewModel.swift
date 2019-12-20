//
//  HomeViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

struct HomeViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    let userInfo: UserInfoProtocol
    let authManager: AuthProtocol
    
    var userIsLogged: Bool {
        return authManager.userIsLogged
    }
    
    var currentUserUid: String? {
        return authManager.userUid
    }
    
    func getEvents(completion: @escaping ([EventModel]?) -> Void) {
        databaseManager.getEvents { arrayId, arrayData in
            var i = 0
            var events = arrayData.compactMap({ (data) -> EventModel? in
                guard let id = arrayId[i],
                    let createdBy = data!["createdBy"] as? String,
                    let createdAt = data!["createdAt"] as? String,
                    let updatedAt = data!["updatedAt"] as? String,
                    let eventAt = data!["eventAt"] as? String,
                    let name = data!["name"] as? String,
                    let place = data!["place"] as? String,
                    let description = data!["description"] as? String,
                    let userIds = data!["userIds"] as? [String],
                    let waitingUserIds = data!["waitingUserIds"] as? [String],
                    let groupePicture = data!["groupePicture"] as? String,
                    let userMaxNumber = data!["userMaxNumber"] as? NSNumber else {
                        i += 1
                        return nil
                }
                i += 1
                return EventModel(id: id, createdBy: createdBy, createdAt: createdAt, updatedAt: updatedAt, eventAt: eventAt, name: name, place: place, description: description, userIds: userIds, waitingUserIds: waitingUserIds, groupePicture: groupePicture, userMaxNumber: userMaxNumber)
            })
            events = self.sortByPresence(events: events)
            completion(events)
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
    
    private func sortByPresence(events: [EventModel]) -> [EventModel] {
        var groups = [EventModel]()
        var myGroups = [EventModel]()
        
        myGroups.append(EventModel(id: "", createdBy: "", createdAt: "", updatedAt: "", eventAt: "", name: "Mes Groupes", place: "", description: "", userIds: [""], waitingUserIds: [""], groupePicture: "", userMaxNumber: 0))
        groups.append(EventModel(id: "", createdBy: "", createdAt: "", updatedAt: "", eventAt: "", name: "Groupes Disponibles", place: "", description: "", userIds: [""], waitingUserIds: [""], groupePicture: "", userMaxNumber: 0))
        if (self.currentUserUid == nil) {
            return (events)
        }
        for (_, event) in events.enumerated() {
            if (event.userIds.contains(self.currentUserUid!)) {
                myGroups.append(event)
            } else {
                groups.append(event)
            }
        }
        if (myGroups.count == 1) {
            myGroups.remove(at: 0)
        }
        if (groups.count == 1) {
            groups.remove(at: 0)
        }
        myGroups += groups
        return (myGroups)
    }
    
    func getImage(_ url_str:String, _ imageView: UIImageView) {
        if ((URL(string: url_str)) != nil) {
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
