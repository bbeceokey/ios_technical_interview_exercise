//
//  PollexaUITests.swift
//  PollexaUITests
//
//  Created by Busra Ece on 28.06.2024.
//

import XCTest

final class PollexaUITests: XCTestCase {
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            
            let postscollectionviewCollectionView = XCUIApplication().collectionViews["postsCollectionView"]
            let post1Option2Image = postscollectionviewCollectionView/*@START_MENU_TOKEN@*/.images["post_1_option_2"]/*[[".cells.images[\"post_1_option_2\"]",".images[\"post_1_option_2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            post1Option2Image.swipeUp()
            
            let element = postscollectionviewCollectionView.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
            element.swipeUp()
            element.swipeUp()
            
            let element3 = postscollectionviewCollectionView.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
            let element2 = element3.children(matching: .other).element(boundBy: 1)
            element2.swipeUp()
            element2.swipeUp()
            element3.swipeUp()
            element3.children(matching: .other).element(boundBy: 0).swipeUp()
            element3.swipeUp()
            
        }
    }
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    
    func testDiscoverViewControllerUIElements() throws {
        let collectionView = app.collectionViews["postsCollectionView"]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: collectionView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(collectionView.exists, "The collection view should exist")
        
        // Swipe up on the first element
        let firstElement = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstElement.exists, "The first cell should exist")
        firstElement.swipeUp()
        
        // Swipe up on the second element
        let secondElement = collectionView.cells.element(boundBy: 1)
        XCTAssertTrue(secondElement.exists, "The second cell should exist")
        secondElement.swipeUp()
        
        // Swipe down on the collection view
        collectionView.swipeDown()
        
        
        let likeButton = firstElement.buttons["likeButton"]
        XCTAssertFalse(likeButton.exists, "The like button should exist in the first cell")
    }
}
