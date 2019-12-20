//
//  ProfileViewContoller.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewContoller: UIViewController, GIDSignInUIDelegate {
    
    let viewModel = ProfileViewModel(userInfo: UserInfoFirebase(), authManager: FirebaseAuth(), databaseManager: FirebaseDatabaseManager())
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        userEmail.text = viewModel.userEmail
        userName.text = viewModel.userName
        viewModel.getImage(viewModel.userPhotoUrl!, picture)
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        picture.layer.borderWidth = 5.0
        picture.layer.borderColor = UIColor(red: 239/255, green: 195/255, blue: 46/255, alpha: 1.0).cgColor
    }
    
    @IBAction func logOut() {
        GIDSignIn.sharedInstance()?.signOut()
        viewModel.logOut {[weak self] error in
            if error {
                self?.displayError(message: "Une erreur est survenue lors de la déconexion de votre compte High5. Merci de réessayer ultérieurement.")
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteProfile(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Attention",
                                                    message: "Etes vous sûre de vouloir supprimer votre compte",
                                                    preferredStyle: .alert)
        let backAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
        let doneAction = UIAlertAction(title: "Suprimer mon compte", style: .destructive, handler:
        { action in
            self.viewModel.deleteUser(completion: { (error) in
                if (error) {
                    return
                }
                self.navigationController?.popToRootViewController(animated: true)
            })
        })
        alertViewController.addAction(backAction)
        alertViewController.addAction(doneAction)
        present(alertViewController, animated: true)
    }
    
    @IBAction func edditProfile(_ sender: Any) {
        displayView(viewId: "EditUserProfileVC")
    }
    
}

