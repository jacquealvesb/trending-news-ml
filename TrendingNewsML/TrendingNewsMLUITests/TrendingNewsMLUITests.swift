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
   
    /*
    func testCategoriesButtons() {
        let app = XCUIApplication()
        app.launch()
                
        let category = "Entretenimento"
        let categoryButton = app.scrollViews.otherElements.buttons[category]
        let minTrendingWordsCount = 5
        
        XCTAssertEqual(categoryButton.label, category)
        
        categoryButton.tap()
        
        // The trending words in category view is showing
        let trendingWords = app.tables.cells
        XCTAssertGreaterThanOrEqual(trendingWords.count, minTrendingWordsCount + 1)
        
        let trendingCategoryTitle = app.tables.staticTexts[category]
        let size = self.stringCGSize(trendingCategoryTitle.label, withTextStyle: .headline, andContentSizeCategory: .accessibilityExtraLarge)
        
        XCTAssertLessThanOrEqual(size.width, app.tables.firstMatch.frame.width)
    }
 */
    
    func testCategoriesButtonsLabelTruncates() {
        let app = XCUIApplication()
        app.launch()
        
        let category = "Entretenimento"
        let categoryButton = app.scrollViews.otherElements.buttons[category]
        let size = self.stringCGSize(categoryButton.label, withTextStyle: .subheadline)
        let padding: CGFloat = 10
        
        XCTAssertLessThanOrEqual(size.width + (2 * padding), categoryButton.frame.width)
    }
    
    func testCategoriesButtonsLabelAcessibility() {
        let app = XCUIApplication()
        app.launch()
        
        let category = "Entretenimento"
        let categoryButton = app.scrollViews.otherElements.buttons[category]
        let elementsYs = app.scrollViews.otherElements.buttons.allElementsBoundByIndex.map { (element) -> CGFloat in
            return element.frame.midY
        }
        let size = self.stringCGSize(categoryButton.label, withTextStyle: .caption2, andContentSizeCategory: .accessibilityExtraLarge)
        let padding: CGFloat = 10
        
        let hasTwoColumns = Set(elementsYs).count != app.scrollViews.otherElements.buttons.allElementsBoundByIndex.count
        let textFitsOnButton = size.width + (2 * padding) <= categoryButton.frame.width
        
        XCTAssert(hasTwoColumns || textFitsOnButton)
    }
    
    func testAnalyseTextLabelAcessibility() {
        let app = XCUIApplication()
        app.launch()
        
        let analyseTextLabel = app.scrollViews.otherElements.staticTexts["Analisar notícia"]
        let words = analyseTextLabel.label.split(separator: "\n")
        let longestWord = words.max(by: {$1.count > $0.count}) ?? ""
        let size = self.stringCGSize(String(longestWord), withTextStyle: .subheadline, andContentSizeCategory: .accessibilityExtraLarge)
        
        let hasLineBreak = words.count >= 1
        let textFitsOnLabel = size.height <= analyseTextLabel.frame.height
        
        XCTAssert(hasLineBreak || textFitsOnLabel)
    }
}

// MARK: - Support functions
extension TrendingNewsMLUITests {
    func stringCGSize(_ string: String, withTextStyle textStyle: UIFont.TextStyle, andContentSizeCategory contentSizeCategory: UIContentSizeCategory? = nil) -> CGSize {
        var size: CGSize = CGSize.zero
        
        if let contentSizeCategory = contentSizeCategory {
            size = (string as NSString).size(
                withAttributes: [
                    NSAttributedString.Key.font:
                        UIFont.preferredFont(forTextStyle: textStyle,
                                            compatibleWith: UITraitCollection.init(
                                                preferredContentSizeCategory: contentSizeCategory
                                            )
                        )
                ]
            )
        } else {
            size = (string as NSString).size(
                withAttributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: textStyle)
                ]
            )
        }
        
        return size
    }
}
