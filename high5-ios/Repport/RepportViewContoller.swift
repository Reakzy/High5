//
//  RepportViewContoller.swift
//  high5
//
//  Created by Arnaud Costa on 19/03/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

class RepportViewController : UIViewController {
    
    let viewModel = RepportViewModel(databaseManager: FirebaseDatabaseManager())
    var eventId_ = String()
    @IBOutlet private  weak var repportContent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendRepport(_ sender: Any) {
        
        if (!eventId_.isEmpty) {
            viewModel.reportEvent(eventId: eventId_, reportContent: repportContent.text ?? "") { error in
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.displaySucsess(message: "Merci pour votre signialement")
            }
            return
        }
    }
    
}
