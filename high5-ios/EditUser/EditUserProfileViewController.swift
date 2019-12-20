//
//  EditUserViewController.swift
//  high5
//
//  Created by Arnaud Costa on 08/03/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//


import UIKit

class EditUserProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var displayName: UITextField!
    @IBOutlet private weak var age: UIDatePicker!
    @IBOutlet weak var picture: UIImageView!
    
    let viewModel = EditUserProfileViewModel(databaseManager: FirebaseDatabaseManager(), userInfo: UserInfoFirebase(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !viewModel.userIsLogged {
            displayView(viewId: "loginVC")
        }
        displayName.text = viewModel.userDisplayName
        viewModel.getImage(viewModel.userPhotoUrl ?? "", picture)
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        picture.layer.borderWidth = 5.0
        picture.layer.borderColor = UIColor(red: 239/255, green: 195/255, blue: 46/255, alpha: 1.0).cgColor
        displayName.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        let date = String().dateToString(date: age.date, format: "MM-dd-yyyy HH:mm:ss.SSS")
        guard displayName.text != nil,
            displayName.text != "" else {
                displayError(message: "Tout les champs doivent étre remplie.")
                return
        }
        viewModel.updateUser(name: displayName.text!, age: date, photoUrl: viewModel.userPhotoUrl!) { (error) in
            if (error) {
                self.displayError(message: "Une erreur est survenue lors de la confirmation de votre compte. Merci de réessayer ultérieurement.")
                return
            }            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        displayName.resignFirstResponder()
        age.resignFirstResponder()
        return true
    }
    
}

