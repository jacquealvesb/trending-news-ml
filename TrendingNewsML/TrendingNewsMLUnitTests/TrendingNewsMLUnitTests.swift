//
//  TrendingNewsMLUnitTests.swift
//  TrendingNewsMLUnitTests
//
//  Created by Jacqueline Alves on 05/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import XCTest
@testable import TrendingNewsML

class TrendingNewsMLUnitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testArticlesRequest() {
        let promise = expectation(description: "Get list of articles of category")
        let timeout: TimeInterval = 5 // 5 seconds
        
        GNews.getArticles(of: .business) { articles in
            XCTAssertGreaterThan(articles.count, 0)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
