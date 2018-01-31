//  Copyright © 2018 I.C.N.H GmbH. All rights reserved.

import UIKit

class ActionButton: UIButton {
    var action: (() -> Void)? {
        didSet {
            if action == nil {
                removeTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
            } else {
                addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
            }
        }
    }
    
    @objc private func handleTouchUpInside() {
        action?()
    }
}
