//
//  troiswrestoTests.swift
//  troiswrestoTests
//
//  Created by etudiant21 on 06/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import XCTest
@testable import troiswresto
import Firebase
import CoreLocation

class troiswrestoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_createResto() {
        let myExpectation = expectation(description: "création")
        FirebaseHelper.createResto(name: "Le kebab", coordinate: CLLocationCoordinate2D (latitude: 43.34, longitude: 3.23) , address: "4 rue de la paix", picture: nil, myCompletion: { error, myKey in
            XCTAssert(error == nil)
            if myKey == nil {
                XCTFail()
            } else {
                XCTAssert(myKey!.count > 2)
            }
            myExpectation.fulfill()
        })
        wait(for: [myExpectation], timeout: 2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
