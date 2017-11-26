//
//  myVelibTests.swift
//  myVelibTests
//
//  Created by etudiant21 on 24/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import XCTest
@testable import myVelib

class myVelibTests: XCTestCase {
    
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
    
    func testTransformString () {
        let string = "392- fjezfojzefizjf"
        let output = string.transformMyTitle(title: string)
        XCTAssert(output == "fjezfojzefizjf")
    }
    
    func testTransformString2 () {
        let string = "392fjezfojzefizjf"
        let output = string.transformMyTitle(title: string)
        XCTAssert(output == "392fjezfojzefizjf")
    }
    
    func testGetStations() {
        let myExpectation = expectation(description: "Wait for stations")
        
        JCDecauxHelper.getStations() {stations in
            
            XCTAssert(stations.count > 500)
            
            if let notreDame = stations.filter({$0.stationId == 4001}).first {
                XCTAssert((notreDame.title ?? "").contains("DAME"))
            } else {
                XCTFail()
            }
            
            myExpectation.fulfill()
        }
        
        wait(for: [myExpectation], timeout: 1.5)
        
    }
    
    func testGetContracts() {
        let myExpectation = expectation(description: "Wait for contracts")
        
        JCDecauxHelper.getContracts() {contracts in
            
            XCTAssert(contracts.count > 10)
            
            if let paris = contracts.filter({$0.name == "Paris"}).first {
                XCTAssert((paris.name).contains("Paris"))
            } else {
                XCTFail()
            }
            
            myExpectation.fulfill()
        }
        
        wait(for: [myExpectation], timeout: 1.5)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
