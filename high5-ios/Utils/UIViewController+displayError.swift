//
//  UIViewController+AlertPopUp.swift
//  high5
//
//  Created by Arnaud Costa on 24/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(message: String?) {
        let alertViewController = UIAlertController(title: "Erreur",
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .cancel,
                                     handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }
}
