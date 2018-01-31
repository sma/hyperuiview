//  Copyright © 2018 I.C.N.H GmbH. All rights reserved.

import UIKit

class ViewController: UIViewController {

    var h: HyperApp!
    
    override func loadView() {
        view = FrameLayout()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        h = HyperApp(view: view)
        
        let s = """
        const state = {
          count: 0
        }

        const actions = {
          down: value => state => ({ count: state.count - value }),
          up: value => state => ({ count: state.count + value })
        }

        const view = (state, actions) =>
          h("div", {}, [
            h("h1", {}, state.count),
            state.count > 0 ? h("button", { onclick: () => actions.down(1), title: "-" }) : null,
            h("button", { onclick: () => actions.up(1), title: "+" }),
          ])

        app(state, actions, view, document.body)
        """
        
        _ = h.evaluate(s)
    }
}
