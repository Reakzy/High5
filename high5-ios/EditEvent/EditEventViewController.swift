//
//  EditEventController.swift
//  high5
//
//  Created by Arnaud Costa on 08/03/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController, UITextFieldDelegate {
    
    var eventId_ = String()
    private var nbMax = 0
    @IBOutlet private weak var eventName: UITextField!
    @IBOutlet private weak var eventDate: UIDatePicker!
    @IBOutlet private weak var eventPlace: UITextField!
    @IBOutlet private weak var eventDescription: UITextField!
    @IBOutlet private weak var eventUserMaxNumber: UITextField!
    
    let viewModel = EditEventViewModel(databaseManager: FirebaseDatabaseManager(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventName.delegate = self
        self.eventPlace.delegate = self
        self.eventDescription.delegate = self
        self.eventUserMaxNumber.delegate = self
        self.eventUserMaxNumber.keyboardType = UIKeyboardType.decimalPad
        
        viewModel.getEvent(eventId: eventId_) { (event) in
            guard let event = event else {
                return
            }
            self.nbMax = event.userIds.count
            self.eventName.text = event.name
            self.eventPlace.text = event.place
            self.eventDescription.text = event.description
            self.eventUserMaxNumber.text = String(Int(truncating: event.userMaxNumber))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventName.resignFirstResponder()
        eventPlace.resignFirstResponder()
        eventDescription.resignFirstResponder()
        eventUserMaxNumber.resignFirstResponder()
        return(true)
    }
    
    @IBAction func updateEvent(_ sender: Any) {
        let nb = Int(eventUserMaxNumber.text ?? "") ?? 0
        guard eventName.text != "",
            eventPlace.text != "",
            eventDescription.text != "",
            eventUserMaxNumber.text != "" else {
              displayError(message: "Tout les champs doivent étre remplie.")
            return
        }
        if (nb > 2 && nb > self.nbMax) {
            viewModel.updateEvent(eventId: eventId_, name: eventName.text!, date: String().dateToString(date: eventDate.date, format: "MM-dd-yyyy HH:mm:ss.SSS"), place: eventPlace.text!, desc: eventDescription.text!, maxMembers: nb, completion: { (error) in
                if error {
                    self.displayError(message: "Une erreur c'est produite, veuillez reeseiller plus tard.")
                    return
                }
                self.navigationController?.popViewController(animated: true)
                return
            })
        } else {
            displayError(message: "Le nombre de participent doit etre un chiffre et superieur à " + String(self.nbMax) + ".")
        }
    }
}
