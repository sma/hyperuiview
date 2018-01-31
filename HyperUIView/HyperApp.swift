import UIKit
import JavaScriptCore

extension UIView {
    @objc func setAttribute(_ name: String, value: Any?) {
        switch name {
        case "backgroundColor":
            backgroundColor = value as? UIColor
        default:
            print("CANNOT set attribute \(name)")
        }
    }
}

extension UILabel {
    override func setAttribute(_ name: String, value: Any?) {
        switch name {
        case "text":
            text = value as? String
        default:
            super.setAttribute(name, value: value)
        }
    }
}

extension UIButton {
    override func setAttribute(_ name: String, value: Any?) {
        switch name {
        case "title":
            backgroundColor = .orange
            setTitle(value as? String ?? (value as? JSValue)?.toString(), for: .normal)
        default:
            super.setAttribute(name, value: value)
        }
    }
}

extension ActionButton {
    override func setAttribute(_ name: String, value: Any?) {
        switch name {
        case "action":
            action = {
                _ = (value as? JSValue)?.call(withArguments: nil)
            }
        default:
            super.setAttribute(name, value: value)
        }
    }
}

@objc
protocol DocumentExports: class, JSExport {
    func createTextNode(_ text: String) -> Element
    func createElement(_ name: String) -> Element
    
    var body: Element { get }
    
    func setTimeout(_ callback: JSValue)
}

@objc
protocol ElementExports: class, JSExport {
    var name: String { get }
    var children: [Element] { get }
    var nodeValue: String? { get set }

    func appendChild(_ child: Element) -> Element
    func insertBefore(_ child: Element, _ reference: Element?) -> Element
    func removeChild(_ child: Element) -> Element
    
    func getAttribute(_ name: String) -> JSValue?
    func setAttribute(_ name: String, _ value: JSValue?)
    func removeAttribute(_ name: String)
    
    var onclick: JSValue? { get set }
}

@objc
class Document: NSObject, DocumentExports {
    let body: Element
    
    init(body: Element) {
        self.body = body
    }
    
    func createTextNode(_ text: String) -> Element {
        let node = Element(name: "")
        node.nodeValue = text
        return node
    }
    
    func createElement(_ name: String) -> Element {
        return Element(name: name)
    }
    
    // MARK: -
    
    func setTimeout(_ callback: JSValue) {
        DispatchQueue.main.async {
            callback.call(withArguments: nil)
        }
    }
}

@objc
class Element: NSObject, ElementExports {
    let name: String
    let view: UIView
    var children: [Element] = []
    weak var parent: Element?
    
    init(name: String, view: UIView) {
        self.name = name
        self.view = view
    }
    
    convenience init(name: String) {
        self.init(name: name, view: Element.createView(name))
    }
    
    static func createView(_ name: String) -> UIView {
        switch name {
        case "": return UILabel()
        case "div": return ColumnLayout()
        case "button": return ActionButton()
        default: return ColumnLayout()
        }
    }
    
    func appendChild(_ child: Element) -> Element {
        return insertBefore(child, nil)
    }

    func insertBefore(_ child: Element, _ reference: Element?) -> Element {
        if let i = children.index(where: { $0 === reference }) {
            print("insert \(child.name) into \(name)")
            _ = child.parent?.removeChild(child)
            children.insert(child, at: i)
            child.parent = self
            //---
            view.insertSubview(child.view, at: i)
            //---
        } else {
            print("append \(child.name) to \(name)")
            _ = child.parent?.removeChild(child)
            children.append(child)
            child.parent = self
            //---
            view.addSubview(child.view)
            //---
        }
        return child
    }
    
    func removeChild(_ child: Element) -> Element {
        if let i = children.index(where: { $0 === child }) {
            print("remove \(child.name) from \(name)")
            children.remove(at: i)
            child.parent = nil
            //---
            child.view.removeFromSuperview()
            //---
        }
        return child
    }
    
    private var attributes: [String: Any] = [:]
    
    func getAttribute(_ name: String) -> JSValue? {
        return attributes[name] as? JSValue
    }
    
    func setAttribute(_ name: String, _ value: JSValue?) {
        print("set \(name) to '\(value?.debugDescription ?? "nil")'")
        attributes[name] = value
        //---
        view.setAttribute(name, value: value)
        //---
    }
    
    func removeAttribute(_ name: String) {
        setAttribute(name, nil)
    }
    
    var nodeValue: String? {
        didSet {
            print("set #text to '\(nodeValue ?? "nil")'")
            view.setAttribute("text", value: nodeValue)
        }
    }
    
    var onclick: JSValue? {
        didSet {
            view.setAttribute("action", value: onclick)
        }
    }
}

class HyperApp {
    let context: JSContext
    
    init(view: UIView) {
        let body = Element(name: "body", view: view)
        let document = Document(body: body)
        
        context = JSContext()!
        context.exceptionHandler = { _, value in print(value!) }
        context.globalObject.setValue(document, forProperty: "document")
        
//        let document = JSValue(newObjectIn: context)!
//
//        func createElement(_ name: String) -> Element {
//            return Element(name: name)
//        }
//
//        func createTextNode(_ text: String) -> Element {
//            let node = Element(name: "")
//            node.nodeValue = text
//            return node
//        }
//
//        func setTimeout(_ callback: JSValue) {
//            DispatchQueue.main.async {
//                callback.call(withArguments: nil)
//            }
//        }
//
//        document.setValue(body, forProperty: "body")
//        document.setValue(createElement, forProperty: "createElement")
//        document.setValue(createTextNode, forProperty: "createTextNode")
//        context.globalObject.setValue(document, forProperty: "document")
//        context.globalObject.setValue(setTimeout, forProperty: "setTimeout")
        
        
        context.evaluateScript("""
        function setTimeout(callback) {
            return document.setTimeout(callback)
        }
        """)
        
        let bundle = Bundle(for: HyperApp.self)
        let url = bundle.url(forResource: "hyperapp", withExtension: "js")!
        let script = try! String(contentsOf: url)
        context.evaluateScript(script, withSourceURL: url)
    }
    
    func evaluate(_ script: String) -> JSValue {
        let result = context.evaluateScript(script)!
        if let exception = context.exception {
            fatalError(exception.description)
        }
        return result
    }
}
