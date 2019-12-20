//
//  ProfileViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 22/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation
import Firebase

struct ProfileViewModel {
    
    let userInfo: UserInfoProtocol
    let authManager: AuthProtocol
    let databaseManager: DatabaseManagerProtocol
    
    func logOut(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch {
            completion(true)
        }
        completion(false)
    }
    
    var clientId: String? {
        return authManager.clientId
    }
    
    var userPhotoUrl: String? {
        return userInfo.userPhotoUrl
    }
    
    var userEmail: String? {
        return userInfo.userEmail
    }
    
    var userName: String? {
        return userInfo.userDisplayName
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void) {
        let user = High5User(id: userInfo.currentUser?.id, email : "toDelete", profilPicture : "", birthdayDate : "", name : "", block: [])
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
    
    func getImage(_ url_str:String, _ imageView:UIImageView) {
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
