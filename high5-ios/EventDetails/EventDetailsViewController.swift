//
//  EventDetailsViewController.swift
//  high5
//
//  Created by Arnaud Costa on 21/01/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

class EventDetailsViewController : UIViewController {
    
    var eventId_ = String()
    var btnTitle_ = String()
    private var eventName_ = String()
    private var eventCreatedBy_ = String()
    private var waitingUserIds = [String]()
    private var userIds = [String]()
    
    @IBOutlet weak var eventPicture: UIImageView!
    @IBOutlet private weak var eventName: UILabel!
    @IBOutlet private weak var eventDate: UILabel!
    @IBOutlet private weak var eventTime: UILabel!
    @IBOutlet private weak var eventPalce: UILabel!
    @IBOutlet private weak var eventNbRegister: UILabel!
    @IBOutlet private weak var eventDesc: UITextView!
    @IBOutlet private weak var eventOwner: UILabel!
    @IBOutlet private weak var btn: UIButton!
    @IBOutlet weak var picture: UIImageView!
    
    let viewModel = EventDetailsViewModel(databaseManager: FirebaseDatabaseManager(), userInfo: UserInfoFirebase(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !viewModel.userIsLogged {
            displayView(viewId: "loginVC")
        }
        viewModel.getEvent(eventId: self.eventId_) { [weak self] event in
            guard let event = event else {
                return
            }
            self?.eventName_ = event.name
            self?.waitingUserIds = event.waitingUserIds
            self?.userIds = event.userIds
            self?.eventCreatedBy_ = event.createdBy
            self?.eventName.text = event.name
            self?.eventDate.text = String().dateToString(date: Date().stringToDate(date: event.eventAt, format: "MM-dd-yyyy"), format: "MM-dd-yyyy")
            self?.eventTime.text = String().dateToString(date: Date().stringToDate(date: event.eventAt, format: "HH:mm"), format: "HH:mm")
            self?.eventPalce.text = event.place
            self?.eventNbRegister.text = String(event.userIds.count) + "/" + String(event.userMaxNumber.intValue)
            self?.eventDesc.text = event.description
            self?.viewModel.getImage(event.groupePicture, (self?.eventPicture)!)
            self?.btn.setTitle(self?.btnTitle_, for: .normal)
            self?.viewModel.getUser(uid: event.createdBy, completion: { user in
                guard user != nil else {
                    return
                }
                self?.viewModel.getImage(user?.profilPicture ?? "", (self?.picture)!)
                self?.picture.layer.cornerRadius = (self?.picture.frame.size.width)! / 2
                self?.picture.clipsToBounds = true
                self?.eventOwner.text = user?.name
                if (event.waitingUserIds.contains((self?.viewModel.currentUserUid!)!)) {
                    self?.btn.isUserInteractionEnabled = false;
                    self?.btn.setTitle("En attente de validation", for: .normal)
                }
            })
            
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))
    } 
    
    @IBAction func join(_ sender: Any) {
        if (btnTitle_ == "CHAT") {
            navigationController?.popViewController(animated: true)
            return
        }
        joinEvent()
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func joinEvent() {
        self.viewModel.joinEvent(eventId: self.eventId_, uid: self.viewModel.currentUserUid!, completion: { error in
            if error {
                self.displayError(message: "Une erreur est survenue. Merci de réessayer ultérieurement.")
            } else {
               self.displayView(viewId: "tabBarVC")
            }
        })
    }

    private func leaveEvent() {
        self.viewModel.leaveEvent(eventId: self.eventId_, uid: self.viewModel.currentUserUid!, completion: { error in
            if error {
                self.displayError(message: "Une erreur est survenue. Merci de réessayer ultérieurement.")
            } else {
                self.displayView(viewId: "tabBarVC")
            }
        })
    }

    private func deletEvent() {
        self.viewModel.deletEvent(eventId: self.eventId_, completion: { error in
            if error {
                self.displayError(message: "Une erreur est survenue lors de la suppression de l'événement. Merci de réessayer ultérieurement.")
            } else {
                self.displayView(viewId: "tabBarVC")
            }
        })
    }
    
    
    @IBAction func manageEvent(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Gestion de l'evenement.",
                                                    message: "Que voulez vous faire",
                                                    preferredStyle: .alert)
        
        let quiteAction = UIAlertAction(title: "Quitter l'événement", style: .destructive, handler:
        { action in self.leaveEvent() })
        
        let deleteAction = UIAlertAction(title: "Supprimer l'événement", style: .destructive, handler:
        { action in self.deletEvent() })
        
        let manageWatingListAction = UIAlertAction(title: "Liste d'attente", style: .default, handler:
        { action in
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "manageEventVC") as! ManageEventViewController
            newVC.eventId_ = self.eventId_
            self.navigationController?.show(newVC, sender: nil)
        })
        
        let editEventAction = UIAlertAction(title: "Editer l'événement", style: .default, handler:
        { action in
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editEventVC") as! EditEventViewController
            newVC.eventId_ = self.eventId_
            self.navigationController?.show(newVC, sender: nil)
        })
        
        let reportAction = UIAlertAction(title: "Signaler l'événement", style: .default, handler:
        { action in
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepportVC") as! RepportViewController
            newVC.eventId_ = self.eventId_
            self.navigationController?.show(newVC, sender: nil)
        })
        
        let backAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
    
        if (self.eventCreatedBy_ == self.viewModel.currentUserUid) {
            alertViewController.addAction(manageWatingListAction)
            alertViewController.addAction(deleteAction)
            alertViewController.addAction(editEventAction)
        } else if (self.userIds.contains(self.viewModel.currentUserUid!) || self.waitingUserIds.contains(self.viewModel.currentUserUid!)) {
            alertViewController.addAction(reportAction)
            alertViewController.addAction(quiteAction)
        }
        alertViewController.addAction(backAction)
        present(alertViewController, animated: true)
    }
}
