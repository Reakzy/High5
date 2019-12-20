//
//  DatadaseManager.swift
//  high5
//
//  Created by Arnaud Costa on 26/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDatabaseManager : DatabaseManagerProtocol {
 
    func acceptUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        let event = Firestore.firestore().collection("Event").document(eventId)
        
        event.updateData(["userIds": FieldValue.arrayUnion([uid])]) { err in
            if err != nil {
                completion(true)
            } else {
                event.updateData(["waitingUserIds": FieldValue.arrayRemove([uid])]) { err in
                    if err != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func refuseUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        let event = Firestore.firestore().collection("Event").document(eventId)
        
        event.updateData(["waitingUserIds": FieldValue.arrayRemove([uid])]) { err in
            if err != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func kickUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        let event = Firestore.firestore().collection("Event").document(eventId)
        
        event.updateData(["userIds": FieldValue.arrayRemove([uid])]) { err in
            if err != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    

    func createEvent(name: String, date: String, place: String, desc: String, maxMembers : Int) -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        var userIds = [String]()
        let waitingUserIds = [String]()
        var ref: DocumentReference? = nil
        
        userIds.append(currentUser.uid)
        ref = Firestore.firestore().collection("Event").addDocument(data: [
            "createdBy": currentUser.uid,
            "createdAt": String().dateToString(date: Date(), format: "MM-dd-yyyy HH:mm:ss.SSS"),
            "updatedAt": String().dateToString(date: Date(), format: "MM-dd-yyyy HH:mm:ss.SSS"),
            "description": desc,
            "eventAt": date,
            "groupePicture" : "https://image.noelshack.com/fichiers/2019/12/2/1552990035-header-bg.jpg",
            "name": name,
            "place": place,
            "userIds" : userIds,
            "waitingUserIds" : waitingUserIds,
            "userMaxNumber" : maxMembers]) { err in
            if err != nil {
                return
            }
            self.createMessage(eventId: ref!.documentID, userUid: currentUser.uid, content: currentUser.displayName! + " à crée le groupe")
            return
        }
        return true
    }

    func deletUser(uid: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("User").document(uid).delete() { err in
            if err != nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
    func updateEvent(eventId: String, name: String, date: String, place: String, desc: String, maxMembers: Int, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("Event").document(eventId)
            .updateData([
                "eventAt" : date,
                "description" : desc,
                "name" : name,
                "place" : place,
                "userMaxNumber" : maxMembers,
                "updateAt" : String().dateToString(date: Date(), format: "MM-dd-yyyy HH:mm:ss.SSS")
            ]) { err in
                if err != nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
        }
    }
    
    func createMessage(eventId: String, userUid: String, content: String) -> Void {
     Firestore.firestore().collection("Message").addDocument(data: [
            "createdBy": userUid,
            "createdAt": String().dateToString(date: Date(), format: "MM-dd-yyyy HH:mm:ss.SSS"),
            "content":  content,
            "eventId": eventId
        ]) { err in
            if err != nil {
                return
            } else {
                return
            }
        }
    }
    
    func getEvents(completion: @escaping ([String?], [NSDictionary?]) -> Void) {
        Firestore.firestore().collection("Event").addSnapshotListener { (querySnapshot, err) in
            var arrayData = [NSDictionary?]()
            var arrayId = [String?]()

            if err != nil {
                completion([], [])
            } else {
                for document in querySnapshot!.documents {
                    arrayId.append(document.documentID as String)
                    arrayData.append(document.data() as NSDictionary)
                }
                completion(arrayId, arrayData)
            }
        }
    }
    
    func getEvent(eventId: String, completion: @escaping (NSDictionary?) -> Void) {
        Firestore.firestore().collection("Event").document(eventId).addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() as NSDictionary? ?? nil
                completion(dataDescription)
                return
            } else {
                completion(nil)
            }
        }
        
    }
    
    
    func getEventOnce(eventId: String, completion: @escaping (NSDictionary?) -> Void) {
        Firestore.firestore().collection("Event").document(eventId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() as NSDictionary? ?? nil
                completion(dataDescription)
                return
            } else {
                completion(nil)
            }
        }
        
    }
    
    func getMessages(eventId: String, completion: @escaping ([String?], [NSDictionary?]) -> Void) {
        Firestore.firestore().collection("Message").whereField("eventId", isEqualTo: eventId).order(by: "createdAt")
            .addSnapshotListener { querySnapshot, error in
                var arrayData = [NSDictionary?]()
                var arrayId = [String?]()
                
                guard let documents = querySnapshot?.documents else {
                    completion([], [])
                    return
                }
                for document in documents {
                    arrayId.append(document.documentID as String)
                    arrayData.append(document.data() as NSDictionary)
                }
                completion(arrayId, arrayData)
        }
    }
    
    func deletEvent(eventId: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("Event").document(eventId).delete() { err in
            if err != nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
    func joinEvent(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("Event").document(eventId)
            .updateData(["waitingUserIds": FieldValue.arrayUnion([uid])]) { err in
            if err != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func leaveEvent(eventId: String, uid : String, completion: @escaping (Bool) -> Void) {
        let event = Firestore.firestore().collection("Event").document(eventId)
        
        event.updateData(["userIds": FieldValue.arrayRemove([uid])]) { err in
            if err != nil {
                completion(true)
            } else {
                event.updateData(["waitingUserIds": FieldValue.arrayRemove([uid])]) { err in
                    if err != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func createUser(user : High5User, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }

      Firestore.firestore().collection("User").document(currentUser.uid).setData([
            "createdAt": String().dateToString(date: Date(), format: "MM-dd-yyyy HH:mm:ss.SSS"),
            "email" : user.email!,
            "fullName" : user.name!,
            "profilePicture": user.profilPicture!,
            "numberEventCreated" : 0,
            "numberEventJoind" : 0,
            "birthdayDate": user.birthdayDate!]) { err in
            if err != nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
    func updateUser(user : High5User, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        Firestore.firestore().collection("User").document(currentUser.uid).updateData([
            "email" : user.email!,
            "fullName" : user.name!,
            "profilePicture": user.profilPicture!,
            "birthdayDate": user.birthdayDate!]) { err in
                if err != nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
        }
    }

    func getUser(uid: String, completion: @escaping (NSDictionary?) -> Void) {
        Firestore.firestore().collection("User").document(uid).addSnapshotListener { (document, error) in
            guard let document = document, document.exists else {
                completion(nil)
                return
            }
            let dataDescription = document.data() as NSDictionary? ?? nil
            completion(dataDescription)
        }
    }
    
    func getUserOnce(uid: String, completion: @escaping (NSDictionary?) -> Void) {
        Firestore.firestore().collection("User").document(uid).getDocument { (document, error) in
            guard let document = document, document.exists else {
                completion(nil)
                return
            }
            let dataDescription = document.data() as NSDictionary? ?? nil
            completion(dataDescription)
        }
    }
    
    func reportEvent(eventId: String, reportNb : Int, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("Event").document(eventId)
            .updateData([
                "reportCount" : reportNb
            ]) { err in
                if err != nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
        }
    }
    
    func blockUser(uid: String, blockUid: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("User").document(uid)
            .updateData(["block": FieldValue.arrayUnion([blockUid])]) { err in
                if err != nil {
                    Firestore.firestore().collection("User").document(uid)
                        .updateData([
                            "block" : blockUid
                        ]) { err in
                            if err != nil {
                                completion(true)
                                return
                            } else {
                                completion(false)
                                return
                            }
                    }
                    completion(true)
                } else {
                    completion(false)
                }
        }
    }
    
}
