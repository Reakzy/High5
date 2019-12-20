//
//  CreatGroupViewController.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var groupeName: UITextField!
    @IBOutlet private weak var groupeDate: UIDatePicker!
    @IBOutlet private weak var groupePlace: UITextField!
    @IBOutlet private weak var groupeDescription: UITextField!
    @IBOutlet weak var eventUserMax: UITextField!
    let viewModel = CreateEventViewModel(databaseManager: FirebaseDatabaseManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupeName.delegate = self
        self.groupePlace.delegate = self
        self.groupeDescription.delegate = self
        self.eventUserMax.delegate = self
        self.eventUserMax.keyboardType = UIKeyboardType.decimalPad
        groupeDate.setValue(UIColor.white, forKeyPath: "textColor")
        groupeDate.setValue(false, forKey: "highlightsToday")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupeName.resignFirstResponder()
        groupePlace.resignFirstResponder()
        groupeDescription.resignFirstResponder()
        eventUserMax.resignFirstResponder()
        return(true)
    }
    
    @IBAction func createGroupe(_ sender: Any) {
        let nb = Int(eventUserMax.text ?? "") ?? 0
        guard groupeName.text == "",
            groupePlace.text == "",
            groupeDescription.text == "",
            eventUserMax.text == "" else {
                guard nb <= 2 else {
                    guard viewModel.createGroupe(name: groupeName.text!, date: String().dateToString(date: groupeDate.date, format: "MM-dd-yyyy HH:mm:ss.SSS"), place: groupePlace.text!, desc: groupeDescription.text!, maxMembers: nb) else {
                        displayError(message: "Une erreur c'est produite, veuillez reeseiller plus tard.")
                        return
                    }
                    displayView(viewId: "tabBarVC")
                    return
                }
                displayError(message: "Le nombre de participent doit etre un chiffre et superieur à 2.")
                return
        }
        displayError(message: "Tout les champs doivent étre remplie.")
    }
}
