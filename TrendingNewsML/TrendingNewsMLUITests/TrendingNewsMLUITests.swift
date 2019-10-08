//
//  TrendingNewsMLUITests.swift
//  TrendingNewsMLUITests
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import XCTest

class TrendingNewsMLUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testCategoriesButtons() {
        let app = XCUIApplication()
        app.launch()
                
        let category = "Entretenimento"
        let categoryButton = app.scrollViews.otherElements.buttons[category]
        
        XCTAssertEqual(categoryButton.label, category)
        
        categoryButton.tap()
        
        // The trending words in category view is showing
        
        let trendingWords = app.tables.firstMatch.cells
        XCTAssertEqual(trendingWords.count, 5)
    }
    
    func testCategoriesButtonsLabelTruncates() {
        let app = XCUIApplication()
        app.launch()
        
        let category = "Entretenimento"
        let categoryButton = app.scrollViews.otherElements.buttons[category]
        
        let size: CGSize = (categoryButton.label as NSString).size(
            withAttributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)
            ]
            
        )
        let padding: CGFloat = 10
        
        XCTAssertLessThanOrEqual(size.width + (2 * padding), categoryButton.frame.width)
    }
    
    func testCategoriesButtonsLabelAcessibility() {
        let app = XCUIApplication()
        app.launch()
        
        let category = "Entretenimento"
        let categoryButton = app.scrollViews.otherElements.buttons[category]
        
        let size: CGSize = (categoryButton.label as NSString).size(
            withAttributes: [
                NSAttributedString.Key.font:
                    UIFont.preferredFont(forTextStyle: .subheadline,
                                        compatibleWith: UITraitCollection.init(
                                            preferredContentSizeCategory: UIContentSizeCategory.accessibilityExtraLarge
                                        )
                    )
            ]
            
        )
        let padding: CGFloat = 10
        
        XCTAssertLessThanOrEqual(size.width + (2 * padding), categoryButton.frame.width)
    }
    
    func testAnalyseTextLabelAcessibility() {
        let app = XCUIApplication()
        app.launch()
        
        let analyseTextLabel = app.scrollViews.otherElements.staticTexts["ANALISAR\nNOTÍCIA"]
        
        let size: CGSize = (analyseTextLabel.label as NSString).size(
            withAttributes: [
                NSAttributedString.Key.font:
                    UIFont.preferredFont(forTextStyle: .subheadline,
                                        compatibleWith: UITraitCollection.init(
                                            preferredContentSizeCategory: UIContentSizeCategory.accessibilityExtraLarge
                                        )
                    )
            ]
            
        )
        
        XCTAssertLessThanOrEqual(size.height, analyseTextLabel.frame.height)
    }
}
