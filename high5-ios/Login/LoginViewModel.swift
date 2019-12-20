//
//  LoginViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

struct LoginViewModel {
    
    let authManager: AuthProtocol
    let databaseManager: DatabaseManagerProtocol

    func logIn(idToken : String, accessToken: String, completion: @escaping (Bool) -> Void ) {
        authManager.logIn(idToken: idToken, accessToken: accessToken, completion: { isAuth in
            if isAuth {
                completion(true)
                return
            }
            completion(false)
        })
    }

    var clientId: String? {
        return authManager.clientId
    }
    
    var userUid: String? {
        return authManager.userUid
    }
    
    var userIsLogged: Bool {
        return authManager.userIsLogged
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser?.uid
        self.databaseManager.deletUser(uid: uid!, completion: { (error) in
            if (error) {
                completion(true)
            }
            user?.delete { error in
                if error != nil {
                    completion(true)
                }
                GIDSignIn.sharedInstance()?.signOut()
                completion(false)
            }
        })
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
    
}
