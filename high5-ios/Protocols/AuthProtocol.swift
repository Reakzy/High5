//
//  LoginProtocol.swift
//  high5
//
//  Created by Arnaud Costa on 04/12/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation

protocol AuthProtocol {
    var clientId: String? { get }
    var userIsLogged: Bool { get }
    var userUid: String? { get }
    func logIn(idToken : String, accessToken: String, completion: @escaping (Bool) -> Void)
}
