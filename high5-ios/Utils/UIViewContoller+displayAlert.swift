//
//  UIViewContoller+displayAlert.swift
//  high5
//
//  Created by Arnaud Costa on 28/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(message: String?) {
        let alertViewController = UIAlertController(title: "Attention",
                                                    message: message,
                                                    preferredStyle: .alert)
        let backAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
        let doneAction = UIAlertAction(title: "Suprimer mon compte", style: .destructive, handler: nil)

        alertViewController.addAction(backAction)
        alertViewController.addAction(doneAction)
        present(alertViewController, animated: true)
    }
    
    func displaySucsess(message: String?) {
        let alertViewController = UIAlertController(title: "Success",
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .cancel,
                                     handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }
}
