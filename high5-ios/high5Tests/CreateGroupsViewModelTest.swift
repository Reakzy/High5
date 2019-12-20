//
//  CreateGroupe.swift
//  high5Tests
//
//  Created by Arnaud Costa on 04/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import Foundation

@testable import high5
import XCTest

class CreateGroupsViewModelTest : XCTestCase {
    
    struct MockFirebaseDatabaseManagerData: DatabaseManagerProtocol {
        func getEventUsers(eventId: String, completion: @escaping ([String?], [NSDictionary?]) -> Void) {
            completion([], [])
        }
        
        func joinEvent(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
            completion(false)
        }
        
        func deletEvent(eventId: String, completion: @escaping (Bool) -> Void) {
            completion(false)
        }
        
        func leaveEvent(eventId: String, uid: String, completion: @escaping (Bool) -> Void) {
            completion(false)
        }
        
        func createGroup(name: String, date: String, place: String, desc: String, maxMembers: Int) -> Bool {
            return true
        }
        
        func createMessage(eventId: String, userUid: String, content: String) -> Bool {
            return true
        }
        
        func getEvents(completion: @escaping ([String?], [NSDictionary?]) -> Void) {
            completion([], [])
        }
        
        func getMessages(eventId: String, completion: @escaping ([String?], [NSDictionary?]) -> Void) {
            completion([], [])
        }
        
        func getEvent(eventId: String, completion: @escaping (NSDictionary?) -> Void) {
            completion( NSDictionary())
        }
    }
    
    func testCreatEvent() {
        let mockFirebaseDatabaseManager = MockFirebaseDatabaseManagerData()
        let viewModel = CreateGoupeViewModel(databaseManager: mockFirebaseDatabaseManager)
        
        XCTAssertTrue(viewModel.createGroupe(name: "Test", date: "Date", place: "Epitech", desc: "Test EVent", maxMembers: 8))
    
    }
    
//    func testCreatEventNil() {
//        let mockFirebaseDatabaseManager = MockFirebaseDatabaseManagerData()
//        let viewModel = CreateGoupeViewModel(databaseManager: mockFirebaseDatabaseManager)
//        
//        XCTAssertFalse(viewModel.createGroupe(name: "", date: "", place: "", desc: "", maxMembers: 0))
//        
//    }
    
}
