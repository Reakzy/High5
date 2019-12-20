//
//  EditEventViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 08/03/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

struct EditEventViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    let authManager: AuthProtocol
    
    var userIsLogged: Bool {
        return authManager.userIsLogged
    }
    
    var currentUserUid: String? {
        return authManager.userUid
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
    
    func updateEvent(eventId: String, name: String, date: String, place: String, desc: String, maxMembers: Int, completion: @escaping (Bool) -> Void) {
        databaseManager.updateEvent(eventId: eventId, name: name, date: date, place: place, desc: desc, maxMembers: maxMembers) { (error) in
            completion(error)
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
