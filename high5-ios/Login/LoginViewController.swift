//
//  LoginViewController.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet private weak var high5Title: UITextField!
    let viewModel = LoginViewModel(authManager: FirebaseAuth(), databaseManager: FirebaseDatabaseManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = viewModel.clientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        high5Title.font = UIFont(name : "KaushanScript-Regular", size: 90.0)
        if viewModel.userIsLogged {
            viewModel.getUser(uid: viewModel.userUid!) { (user) in
                if (user != nil) {
                    self.displayView(viewId: "tabBarVC")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.userIsLogged {
            viewModel.getUser(uid: viewModel.userUid!) { (user) in
                if (user != nil) {
                    if (user!.email == "toDelete") {
                        self.viewModel.deleteUser(completion: { (error) in
                            print(error)
                            return
                        })
                    } else {
                        self.displayView(viewId: "tabBarVC")
                    }
                }
            }
        }
    }

    @IBAction func googleLoginDidHit(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if (error != nil) {
            if (error!.localizedDescription != "The user canceled the sign-in flow.") {
                displayError(message: "Une erreur est survenue lors de la connexion à High5. Merci de réessayer ultérieurement.")
                return
            }
        } else {
            viewModel.logIn(idToken: user.authentication.idToken, accessToken: user.authentication.accessToken, completion: { [weak self] isConnected in
                if isConnected {
                    self?.displayView(viewId: "tabBarVC")
                }
                else {
                    self?.displayError(message: "Une erreur est survenue lors de la connexion à High5. Merci de réessayer ultérieurement.")
                }
            })
        }
    }
}
