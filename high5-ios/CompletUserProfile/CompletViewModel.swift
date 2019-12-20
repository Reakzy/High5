//
//  CompletViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 12/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

struct CompletProfileViewModel {
    
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
    
    var displayName: String? {
        return userInfo.userDisplayName
    }
    
    func creatUser(name : String, age : String, photoUrl : String, completion: @escaping (Bool) -> Void) {
        let user = High5User(id: currentUserUid, email : userInfo.userEmail, profilPicture : photoUrl, birthdayDate : age, name : name, block: [])
        databaseManager.createUser(user : user) { (error) in
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
