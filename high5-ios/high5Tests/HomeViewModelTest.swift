//
//  FirebaseAuth.swift
//  high5Tests
//
//  Created by Arnaud Costa on 04/12/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

@testable import high5
import XCTest

class HomeViewModelTest : XCTestCase {
    
    
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
            completion(["eventIdOne", "eventIdTwo"], [["createdBy" : "uid", "createdAt" : "date", "updatedAt" : "date", "eventAt" : "date", "name" : "EventName", "place" : "Test", "description" : "eventDesc", "userIds" : ["uid"], "groupePicture" : "picture", "userMaxNumber" : 8]])
        }
        
        func getMessages(eventId: String, completion: @escaping ([String?], [NSDictionary?]) -> Void) {
            completion([], [])
        }
        
        func getEvent(eventId: String, completion: @escaping (NSDictionary?) -> Void) {
            completion(nil)
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
            completion(nil)
        }
        

    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetEvents() {
        // when the idToken and accessToken or nil
        let mockFireBaseUserInfo = MockFirebaseValidUserInfoProtocol()
        let mockFirebaseDatabaseManager = MockFirebaseDatabaseManagerData()
        
        let viewModel = HomeViewModel(databaseManager: mockFirebaseDatabaseManager, userInfo: mockFireBaseUserInfo)
        XCTAssertTrue(viewModel.userIsLogged)
        XCTAssertEqual(mockFireBaseUserInfo.userDisplayName, "Arnaud")
        XCTAssertEqual(mockFireBaseUserInfo.userEmail, "arnaud.costa1@gmail.com")
        XCTAssertNil(mockFireBaseUserInfo.userPhotoUrl)
        XCTAssertTrue((mockFireBaseUserInfo.currentUser != nil))
        XCTAssertEqual(mockFireBaseUserInfo.currentUserUid, "myuid")
        
        viewModel.getEvents { events in
            XCTAssertFalse(events!.isEmpty)
            XCTAssertTrue(events!.count == 1)
        }
    }
    
    func testEmptyGetEvnets() {
        // when the idToken and accessToken or nil
        let mockFireBaseUserInfo = MockFirebaseValidUserInfoProtocol()
        let mockFirebaseDatabaseManager = MockFirebaseDatabaseManagerNilData()
        
        let viewModel = HomeViewModel(databaseManager: mockFirebaseDatabaseManager, userInfo: mockFireBaseUserInfo)
    
        viewModel.getEvents { events in
            XCTAssertTrue(events!.isEmpty)
        }
    }
    
    
}
