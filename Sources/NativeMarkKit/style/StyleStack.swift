import Foundation
import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#elseif canImport(WatchKit)
import WatchKit
#else
#error("Unsupported platform")
#endif

protocol ExpressibleAsAttributes {
    func attributes() -> [NSAttributedString.Key: Any]
}

protocol ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle)
}

final class StyleStack {
    fileprivate enum Scope {
        case blockStyles([BlockStyle])
        case inlineStyles([InlineStyle])
    }
    private var scopes = [Scope]()
    private let stylesheet: StyleSheet
    
    init(stylesheet: StyleSheet) {
        self.stylesheet = stylesheet
    }
    
    func push(_ blockSelector: BlockStyleSelector) {
        scopes.append(.blockStyles(stylesheet.styles(for: blockSelector)))
    }
    
    func push(_ inlineSelector: InlineStyleSelector) {
        scopes.append(.inlineStyles(stylesheet.styles(for: inlineSelector)))
    }
    
    func pop() {
        _ = scopes.popLast()
    }
    
    func attributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        scopes.updateParagraphStyle(paragraphStyle)
        var attributes = scopes.attributes()
        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }
}

extension StyleStack.Scope: ExpressibleAsAttributes {
    func attributes() -> [NSAttributedString.Key: Any] {
        switch self {
        case let .blockStyles(styles):
            return styles.attributes()
        case let .inlineStyles(styles):
            return styles.attributes()
        }
    }
}

extension StyleStack.Scope: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) {
        switch self {
        case let .blockStyles(styles):
            return styles.updateParagraphStyle(paragraphStyle)
        case let .inlineStyles(styles):
            return styles.updateParagraphStyle(paragraphStyle)
        }
    }
}

extension Sequence where Element: ExpressibleAsAttributes {
    func attributes() -> [NSAttributedString.Key: Any] {
        reduce(into: [NSAttributedString.Key: Any]()) { result, style in
            result.merge(style.attributes(), uniquingKeysWith: { _, new in new })
        }
    }
}

extension Sequence where Element: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) {
        for style in self {
            style.updateParagraphStyle(paragraphStyle)
        }
    }
}
