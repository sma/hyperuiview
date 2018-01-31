//
//  HyperUIViewTests.swift
//  HyperUIViewTests
//
//  Created by Stefan Matthias Aust on 31.01.18.
//  Copyright © 2018 I.C.N.H GmbH. All rights reserved.
//

import XCTest
@testable import HyperUIView

class HyperUIViewTests: XCTestCase {
    
    func testH() {
        let h = HyperApp(view: UIView())
        let node = h.evaluate("""
        h("h1", {}, "Hello")
        """)
        XCTAssert(node.isObject)
        XCTAssertEqual(node.forProperty("name").toString(), "h1")
        XCTAssertEqual(node.forProperty("props").toDictionary().count, 0)
        XCTAssertEqual(node.forProperty("children").atIndex(0).toString()!, "Hello")
    }
    
    func testApp() {
        let v = UIView()
        let h = HyperApp(view: v)
        _ = h.evaluate("""
        const view = (state) => h("h1", {}, state.count)
        app({count: 42}, {}, view, document.body)
        """)
        let e = XCTestExpectation()
        DispatchQueue.main.async {
            XCTAssertFalse(v.subviews.isEmpty)
            XCTAssertEqual((v.subviews[0].subviews[0] as! UILabel).text, "42")
            e.fulfill()
        }
        wait(for: [e], timeout: 1)
    }
}
