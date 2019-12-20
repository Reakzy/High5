//
//  UserInfoFirebase.swift
//  high5
//
//  Created by Arnaud Costa on 29/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation
import Firebase

class UserInfoFirebase : UserInfoProtocol {
    
    let databaseManager = FirebaseDatabaseManager()
    var highUser = High5User()
    
    init() {
        
        guard (Auth.auth().currentUser?.uid) != nil else {
            highUser = High5User(id: "", email : Auth.auth().currentUser?.email, profilPicture: Auth.auth().currentUser?.photoURL?.absoluteString, birthdayDate : "0", name : Auth.auth().currentUser?.displayName, block: [])
            return
        }
        databaseManager.getUser(uid: (Auth.auth().currentUser?.uid)!) { [weak self] user in
            if (user === nil) {
                self?.highUser = High5User(id: Auth.auth().currentUser?.uid, email : Auth.auth().currentUser?.email, profilPicture: Auth.auth().currentUser?.photoURL?.absoluteString, birthdayDate : "0", name : Auth.auth().currentUser?.displayName, block: [])
                return
            }
            guard let email = user!["email"] as? String,
                let profilePicture = user!["profilePicture"] as? String,
                let birthdayDate = user!["birthdayDate"] as? String,
                let fullName = user!["fullName"] as? String else {
                    self?.highUser = High5User(id: Auth.auth().currentUser?.uid, email : Auth.auth().currentUser?.email, profilPicture: Auth.auth().currentUser?.photoURL?.absoluteString, birthdayDate : "0", name : Auth.auth().currentUser?.displayName, block: [])
                    return
            }
            var block = user!["block"] as? [String]
            if (block == nil) {
                block = []
            }
            self?.highUser = High5User(id: Auth.auth().currentUser?.uid, email: email, profilPicture: profilePicture, birthdayDate: birthdayDate, name: fullName, block: block)
            
        }
    }
    
    
    var currentUser: High5User? {
        return highUser
    }
    
    var userDisplayName: String? {
        return highUser.name
    }
    
    var userEmail: String? {
        return highUser.email
    }
    
    var userPhotoUrl: String? {
        return highUser.profilPicture
    }
    
    var userBirthdayDate: String? {
        return highUser.birthdayDate
    }
}
