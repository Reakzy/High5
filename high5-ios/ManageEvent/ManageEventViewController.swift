//
//  ManageEventViewController.swift
//  high5
//
//  Created by Arnaud Costa on 12/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

class watingCell: UITableViewCell {
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var refuse: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
}

class acceptedCell: UITableViewCell {
    @IBOutlet weak var refuse: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
}

class ManageEventViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    var eventId_ = String()
    private var users = [High5User]()
    let viewModel = ManageEventViewModel(databaseManager: FirebaseDatabaseManager(), userInfo: UserInfoFirebase(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!viewModel.userIsLogged) {
            self.navigationController?.popViewController(animated: true)
        }
        viewModel.getWatingUsers(eventId: eventId_) { [weak self] (users) in
            //self?.viewModel.getWatingUsers(eventId: (self?.eventId_)!) { [weak self] (watingUsers) in
                self?.users = users
                self?.tableView.reloadData()
            //}
        }
    }
}

extension ManageEventViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watingCell", for: indexPath) as! watingCell
        cell.accept.addTarget(self, action:#selector(accept), for: .touchUpInside)
        cell.refuse.addTarget(self, action:#selector(refuse), for: .touchUpInside)
        cell.accept.accessibilityHint = users[indexPath.row].id!
        cell.refuse.accessibilityHint = users[indexPath.row].id!
        cell.name.text = users[indexPath.row].name
        return cell
    }
    
    @objc func accept(sender: UIButton) {
        let uid = sender.accessibilityHint
        
        viewModel.acceptUser(eventId: self.eventId_, uid: uid!) { error in
            if (error) {
                self.displayError(message: "Une erreur est survenue")
            }
            self.viewModel.getWatingUsers(eventId: self.eventId_) { [weak self] (users) in
                //self?.viewModel.getWatingUsers(eventId: (self?.eventId_)!) { [weak self] (watingUsers) in
                self?.users = users
                self?.tableView.reloadData()
                //}
            }
        }
    }
    
    @objc func refuse(sender: UIButton) {
        let uid = sender.accessibilityHint
        viewModel.refuseUser(eventId: self.eventId_, uid: uid!) { error in
            if (error) {
                self.displayError(message: "Une erreur est survenue")
            }
            self.viewModel.getWatingUsers(eventId: self.eventId_) { [weak self] (users) in
                //self?.viewModel.getWatingUsers(eventId: (self?.eventId_)!) { [weak self] (watingUsers) in
                self?.users = users
                self?.tableView.reloadData()
                //}
            }
        }
    }
    
}
