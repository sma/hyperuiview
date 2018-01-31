//
//  HyperUIViewUITests.swift
//  HyperUIViewUITests
//
//  Created by Stefan Matthias Aust on 31.01.18.
//  Copyright © 2018 I.C.N.H GmbH. All rights reserved.
//

import XCTest

extension XCUIElement {
    var existsNot: Bool { return !exists }
}

class HyperUIViewUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApp() {
        let app = XCUIApplication()
        // given
        XCTAssert(app.staticTexts["0"].exists)
        XCTAssert(app.buttons["-"].existsNot)
        XCTAssert(app.buttons["+"].exists)

        // when
        app.buttons["+"].tap()
        app.buttons["+"].tap()
        
        // then
        XCTAssert(app.buttons["-"].exists)
        XCTAssert(app.staticTexts["2"].exists)
        
        // and when
        app.buttons["-"].tap()
        app.buttons["-"].tap()
        
        // then
        XCTAssert(app.staticTexts["0"].exists)
        XCTAssert(app.buttons["-"].existsNot)
    }
}
