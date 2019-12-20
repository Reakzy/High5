//
//  GoogleAuth.swift
//  high5
//
//  Created by Arnaud Costa on 28/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class  FirebaseAuth: AuthProtocol {
    
    var clientId: String? {
        return FirebaseApp.app()?.options.clientID
    }
    
    var userUid: String? {
        return Auth.auth().currentUser?.uid
    }

    var userIsLogged: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func logIn(idToken : String, accessToken: String, completion: @escaping (Bool) -> Void) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
}

