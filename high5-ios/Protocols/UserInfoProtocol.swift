//
//  UserInfoProtocol.swift
//  high5
//
//  Created by High5 on 18/12/18.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation

protocol UserInfoProtocol {
    var currentUser: High5User? { get }
    var userDisplayName: String? { get }
    var userEmail: String? { get }
    var userPhotoUrl: String? { get }
    var userBirthdayDate: String? { get }
}
