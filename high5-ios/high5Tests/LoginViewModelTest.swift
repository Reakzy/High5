//
//  FirebaseAuth.swift
//  high5Tests
//
//  Created by Arnaud Costa on 04/12/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

@testable import high5
import XCTest

class LoginViewModelTest : XCTestCase {

    struct MockFirebaseUnvalidOrNilAuthToken: AuthProtocol {
        
        var clientId: String? {
            return nil
        }
        
        func logIn(idToken : String, accessToken: String, completion: @escaping (Bool) -> Void) {
                completion(false)
                return
            }
        }
    
    
    struct MockFirebasValideValidAuthToken: AuthProtocol {
        
        var clientId: String? {
            return "myClientId"
        }
        
        func logIn(idToken : String, accessToken: String, completion: @escaping (Bool) -> Void) {
            completion(true)
            return
        }
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFirebaseAuthNilToken() {
        // when the idToken and accessToken or empty
        let mockFireBase = MockFirebaseUnvalidOrNilAuthToken()
        let viewModel = LoginViewModel(authManager: mockFireBase, userInfo: UserInfoFirebase())
        viewModel.logIn(idToken: "", accessToken: "", completion: {isAuth in
            XCTAssertNil(mockFireBase.clientId)
            XCTAssertFalse(isAuth)
        })
    }

    func testFirebaseAuthUnvalidToken() {
        // when the idToken and accessToken or valid
        let mockFireBase = MockFirebasValideValidAuthToken()
        let viewModel = LoginViewModel(authManager: mockFireBase, userInfo: UserInfoFirebase())
        viewModel.logIn(idToken: "myTokoen", accessToken: "myAccessToken", completion: {isAuth in
            XCTAssertEqual(mockFireBase.clientId, "myClientId")
            XCTAssertTrue(isAuth)
        })
    }

}
