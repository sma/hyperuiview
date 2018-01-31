//  Copyright © 2018 I.C.N.H GmbH. All rights reserved.

import UIKit

extension CGRect {
    func insetBy(_ insets: UIEdgeInsets) -> CGRect {
        var rect = self
        rect.origin.x += insets.left
        rect.origin.y += insets.top
        rect.size.width -= insets.left + insets.right
        rect.size.height -= insets.top + insets.bottom
        return rect
    }
}

class FrameLayout: UIView {
    var insets: UIEdgeInsets = .zero
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var result = CGSize.zero
        for subview in subviews {
            let sz = subview.sizeThatFits(size)
            result.width = max(result.width, sz.width)
            result.height = max(result.height, sz.height)
        }
        result.width += insets.left + insets.right
        result.height += insets.top + insets.bottom
        return result
    }

    override func layoutSubviews() {
        let frame = bounds.insetBy(insets)
        for subview in subviews {
            subview.frame = frame
        }
    }
}

class ColumnLayout: UIView {
    var insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var gap: CGFloat = 10
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var result = CGSize.zero
        for subview in subviews {
            let sz = subview.sizeThatFits(size)
            result.width = max(result.width, sz.width)
            result.height += sz.height
        }
        if !subviews.isEmpty {
            result.height += gap * CGFloat(subviews.count - 1)
        }
        result.width += insets.left + insets.right
        result.height += insets.top + insets.bottom
        return result
    }
    
    override func layoutSubviews() {
        var frame = bounds
        frame.origin.x += insets.left
        frame.origin.y += insets.top
        frame.size.width -= insets.left + insets.right
        frame.size.height -= insets.top + insets.bottom
        for subview in subviews {
            let size = subview.sizeThatFits(bounds.size)
            frame.size.height = size.height
            subview.frame = frame
            frame.origin.y += frame.height
            frame.origin.y += gap
        }
    }
}
