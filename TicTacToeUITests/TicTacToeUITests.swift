//
//  TicTacToeUITests.swift
//  TicTacToeUITests
//
//  Created by Paul Stringer on 31/03/2016.
//  Copyright © 2016 stringerstheory. All rights reserved.
//

import XCTest

class TicTacToeUITests: XCTestCase {
    
    lazy var element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other)
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPlayerOneDiagonalWins() {
        
        element.children(matching: .button).element(boundBy: 0).tap()
        element.children(matching: .button).element(boundBy: 1).tap()
        element.children(matching: .button).element(boundBy: 4).tap()
        element.children(matching: .button).element(boundBy: 2).tap()
        element.children(matching: .button).element(boundBy: 8).tap()
        
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 0).label, "GREEN")
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 4).label, "GREEN")
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 8).label, "GREEN")
        
    }
    
    func testPlayerOneHorizontalWins() {

        element.children(matching: .button).element(boundBy: 3).tap()
        element.children(matching: .button).element(boundBy: 1).tap()
        element.children(matching: .button).element(boundBy: 4).tap()
        element.children(matching: .button).element(boundBy: 2).tap()
        element.children(matching: .button).element(boundBy: 5).tap()
        
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 3).label, "GREEN")
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 4).label, "GREEN")
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 5).label, "GREEN")
        
    }
    
    func testPlayerOneVerticalLineWins() {
        
        element.children(matching: .button).element(boundBy: 0).tap()
        element.children(matching: .button).element(boundBy: 1).tap()
        element.children(matching: .button).element(boundBy: 3).tap()
        element.children(matching: .button).element(boundBy: 2).tap()
        element.children(matching: .button).element(boundBy: 6).tap()
        
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 0).label, "GREEN")
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 3).label, "GREEN")
        XCTAssertEqual(element.children(matching: .button).element(boundBy: 6).label, "GREEN")
        
    }
    
}
