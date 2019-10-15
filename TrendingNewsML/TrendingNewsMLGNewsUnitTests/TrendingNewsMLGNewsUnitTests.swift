//
//  TrendingNewsMLGNewsUnitTests.swift
//  TrendingNewsMLGNewsUnitTests
//
//  Created by Jacqueline Alves on 14/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import XCTest
@testable import TrendingNewsML

class TrendingNewsMLGNewsUnitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
