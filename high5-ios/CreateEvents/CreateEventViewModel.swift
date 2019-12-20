//
//  File.swift
//  high5
//
//  Created by Arnaud Costa on 24/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation

struct CreateEventViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    
    func createGroupe(name: String, date: String, place: String, desc: String, maxMembers : Int) -> Bool {
        if !databaseManager.createEvent(name: name, date: date, place: place, desc: desc, maxMembers: maxMembers) {
              return false
        }
        return true
    }
}
