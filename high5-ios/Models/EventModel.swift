//
//  Group.swift
//  high5
//
//  Created by Arnaud Costa on 26/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation

struct EventModel {
    let id:             String
    let createdBy:      String
    let createdAt:      String
    let updatedAt:      String
    let eventAt:        String
    let name:           String
    let place:          String
    let description:    String
    let userIds:        [String]
    let waitingUserIds: [String]
    let groupePicture:  String
    let userMaxNumber : NSNumber
}
