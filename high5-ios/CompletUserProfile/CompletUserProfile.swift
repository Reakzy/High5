//
//  CompletUserProfile.swift
//  high5
//
//  Created by Arnaud Costa on 12/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

class CompletUserProfile: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var displayName: UITextField!
    @IBOutlet private weak var age: UIDatePicker!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var cguLabel: UILabel!
    
    let viewModel = CompletProfileViewModel(databaseManager: FirebaseDatabaseManager(), userInfo: UserInfoFirebase(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if !viewModel.userIsLogged {
            displayView(viewId: "loginVC")
        }
        displayName.text = viewModel.displayName
        viewModel.getImage(viewModel.userPhotoUrl ?? "", picture)
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        picture.layer.borderWidth = 5.0
        picture.layer.borderColor = UIColor(red: 239/255, green: 195/255, blue: 46/255, alpha: 1.0).cgColor
        displayName.delegate = self
        cguLabel.isUserInteractionEnabled = true
        age.setValue(UIColor.white, forKeyPath: "textColor")
        age.setValue(false, forKey: "highlightsToday")
        cguLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCgu)))
    }
    
    @objc func showCgu() {
        guard let url = URL(string: "http://high5-app.com/cgv.html") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func validateProfile(_ sender: Any) {
        let date = String().dateToString(date: age.date, format: "MM-dd-yyyy HH:mm:ss.SSS")
        guard displayName.text != nil,
            displayName.text != "" else {
                displayError(message: "Tout les champs doivent étre remplie.")
                return
        }
        viewModel.creatUser(name: displayName.text!, age: date, photoUrl: viewModel.userPhotoUrl ?? "") { (error) in
            if (error) {
                self.displayError(message: "Une erreur est survenue lors de la confirmation de votre compte. Merci de réessayer ultérieurement.")
                return
            }
            self.displayView(viewId: "tabBarVC")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        displayName.resignFirstResponder()
        age.resignFirstResponder()
        return true
    }
    
}
