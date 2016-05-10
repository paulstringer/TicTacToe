//
//  TicTacToeUITests.swift
//  TicTacToeUITests
//
//  Created by Paul Stringer on 31/03/2016.
//  Copyright © 2016 stringerstheory. All rights reserved.
//

import XCTest

class TicTacToeUITests: XCTestCase {
    
    lazy var element = XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPlayerOneDiagonalWins() {

        element.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(4).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(8).tap()
        
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(0).label, "GREEN")
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(4).label, "GREEN")
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(8).label, "GREEN")
        
    }
    
    func testPlayerOneHorizontalWins() {

        element.childrenMatchingType(.Button).elementBoundByIndex(3).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(4).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(5).tap()
        
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(3).label, "GREEN")
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(4).label, "GREEN")
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(5).label, "GREEN")
        
    }
    
    func testPlayerOneVerticalLineWins() {
        
        element.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(3).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        element.childrenMatchingType(.Button).elementBoundByIndex(6).tap()
        
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(0).label, "GREEN")
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(3).label, "GREEN")
        XCTAssertEqual(element.childrenMatchingType(.Button).elementBoundByIndex(6).label, "GREEN")
        
    }
    
}
