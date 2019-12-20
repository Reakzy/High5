//
//  DatabaseManagerProtocol.swift
//  high5
//
//  Created by High5 on 18/12/18.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import Foundation

protocol DatabaseManagerProtocol {
    func createEvent(name: String, date: String, place: String, desc: String, maxMembers : Int) -> Bool
    func updateEvent(eventId: String, name: String, date: String, place: String, desc: String, maxMembers: Int, completion: @escaping (Bool) -> Void) 
    func createMessage(eventId: String, userUid: String, content: String) -> Void
    func getEvents(completion: @escaping ([String?], [NSDictionary?]) -> Void)
    func getMessages(eventId : String, completion: @escaping ([String?], [NSDictionary?]) -> Void)
    func getEvent(eventId: String, completion: @escaping (NSDictionary?) -> Void)
    func getEventOnce(eventId: String, completion: @escaping (NSDictionary?) -> Void)
    func joinEvent(eventId: String, uid : String, completion: @escaping (Bool) -> Void)
    func deletEvent(eventId: String, completion: @escaping (Bool) -> Void)
    func leaveEvent(eventId: String, uid : String, completion: @escaping (Bool) -> Void)
    func createUser(user: High5User, completion: @escaping (Bool) -> Void)
    func updateUser(user: High5User, completion: @escaping (Bool) -> Void)
    func deletUser(uid: String, completion: @escaping (Bool) -> Void)
    func getUser(uid: String, completion: @escaping (NSDictionary?) -> Void)
    func getUserOnce(uid: String, completion: @escaping (NSDictionary?) -> Void)
    func acceptUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void)
    func refuseUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void)
    func kickUser(eventId: String, uid: String, completion: @escaping (Bool) -> Void)
    func reportEvent(eventId: String, reportNb: Int, completion: @escaping (Bool) -> Void)
    func blockUser(uid: String, blockUid: String, completion: @escaping (Bool) -> Void)
}
