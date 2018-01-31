//  Copyright © 2018 I.C.N.H GmbH. All rights reserved.

import XCTest
@testable import HyperUIView

class LayoutsTests: XCTestCase {
    
    func testFrameLayout() {
        // given
        let frameLayout = FrameLayout()
        for _ in 1...3 {
            frameLayout.addSubview(UIView())
        }
        
        // when
        frameLayout.frame = CGRect(x: 10, y: 11, width: 12, height: 13)
        frameLayout.layoutIfNeeded()
        
        // then
        for subview in frameLayout.subviews {
            XCTAssertEqual(subview.frame, CGRect(x: 0, y: 0, width: 12, height: 13))
        }
    }
    
    func testFrameLayoutInsets() {
        // given
        let frameLayout = FrameLayout()
        frameLayout.insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        for _ in 1...3 {
            frameLayout.addSubview(UIView())
        }
        
        // when
        frameLayout.frame = CGRect(x: 10, y: 11, width: 12, height: 13)
        frameLayout.layoutIfNeeded()
        
        // then
        for subview in frameLayout.subviews {
            XCTAssertEqual(subview.frame, CGRect(x: 2, y: 1, width: 6, height: 9))
        }
    }
    
    func testFrameLayoutSizeThatFits() {
        // given
        let frameLayout = FrameLayout()
        frameLayout.insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        frameLayout.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 30)))
        frameLayout.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 4)))
        
        // when
        let size = frameLayout.sizeThatFits(.zero)
        
        // then
        XCTAssertEqual(size, CGSize(width: 46, height: 34))
    }
}
