//
//  RepportViewModel.swift
//  high5
//
//  Created by Arnaud Costa on 19/03/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import Foundation

struct RepportViewModel {
    
    let databaseManager: DatabaseManagerProtocol
    
    func reportEvent(eventId: String, reportContent: String, completion: @escaping (Bool) -> Void) {
        databaseManager.getEventOnce(eventId: eventId) { (event) in
            guard event != nil else {
                completion(true)
                return
            }
            var reportNb = event!["reportCount"] as? Int
            if (reportNb == nil) {
                reportNb = 1
            } else {
                reportNb = reportNb! + 1
            }
            self.databaseManager.reportEvent(eventId: eventId, reportNb: reportNb!, completion: { (error) in
                guard error else {
                    completion(true)
                    return
                }
                completion(false)
            })
        }
    }    
}
