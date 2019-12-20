//
//  EditUserViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 08/03/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

struct EditUserProfileViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    let userInfo: UserInfoProtocol
    let authManager: AuthProtocol
    
    var userIsLogged: Bool {
        return authManager.userIsLogged
    }
    
    var currentUserUid: String? {
        return authManager.userUid
    }
    
    var userPhotoUrl: String? {
        return userInfo.userPhotoUrl
    }
    
    var userAge: String? {
        return userInfo.userBirthdayDate
    }
    
    var userDisplayName: String? {
        return userInfo.userDisplayName
    }
    
    func updateUser(name : String, age : String, photoUrl : String, completion: @escaping (Bool) -> Void) {
        let user = High5User(id: currentUserUid, email : userInfo.userEmail, profilPicture : photoUrl, birthdayDate : age, name : name, block: [])
        databaseManager.updateUser(user : user) { (error) in
            if (error) {
                completion(true)
                return
            }
            completion(false)
            return
        }
        return
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
}
