//
//  InterviewTaskTests.swift
//  InterviewTaskTests
//
//  Created by Admin on 07/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//
@testable import InterviewTask
import XCTest

class InterviewTaskTests: XCTestCase {
    
    let localNetworkManager = NetworkManager()
    func testAboutCountryResponseFromeApi() {
        let expectation = self.expectation(description: "Response Parse Expectation")
        localNetworkManager.fetchDataFromServer(withCompletion: { (data, error) in
        XCTAssertNil(error)
        guard let data = data else {
            XCTFail()
            return
        }
        XCTAssertNotNil(data)
        expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 10.0)
    }
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
