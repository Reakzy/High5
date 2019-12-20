//
//  EventDetailsViewModelTest.swift
//  high5Tests
//
//  Created by Arnaud Costa on 03/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import Foundation

@testable import high5
import XCTest

class EventDetailsViewModelTest : XCTestCase {
    
    
    struct MockFirebaseValidUserInfoProtocol: UserInfoProtocol {

        let uid = "myuid"
        let name = "Arnaud"
        let email = "arnaud.costa1@gmail.com"

        var userIsLogged: Bool {
            return true
        }

        var userDisplayName: String? {
            return name
        }

        var userEmail: String? {
            return email
        }

        var userPhotoUrl: URL? {
            return nil
        }

        var currentUser: High5User? {
            return High5User(email: email, uid: uid, name:  name, idToken: nil, accessToken: nil)
        }

        var currentUserUid: String? {
            return uid
        }
    }

    struct MockFirebaseDatabaseManagerNilData: DatabaseManagerProtocol {
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
    
    func testGetEventDetailsNil() {
        // when the idToken and accessToken or nil
        let mockFireBaseUserInfo = MockFirebaseValidUserInfoProtocol()
        let mockFirebaseDatabaseManager = MockFirebaseDatabaseManagerNilData()

        let viewModel = EventDetailsViewModel(databaseManager: mockFirebaseDatabaseManager, userInfo: mockFireBaseUserInfo)
    
        XCTAssertEqual(viewModel.userDisplayName, "Arnaud")
        
        XCTAssertTrue(viewModel.userIsLogged)
        
        viewModel.getEvent(eventId: "eventIdOne") { event in
            XCTAssertNil(event)
        }
    }
}

