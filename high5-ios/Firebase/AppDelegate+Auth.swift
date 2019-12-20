//
//  Firebase.swift
//  high5
//
//  Created by Arnaud Costa on 28/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

extension AppDelegate {
    
    @available(iOS 9.0, *)
    private func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,                       sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
}
