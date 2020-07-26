import Foundation
import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

protocol ExpressibleAsAttributes {
    func updateAttributes(_ attributes: inout [NSAttributedString.Key: Any])
}

protocol ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle, with defaultFont: NativeFont)
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
        var attributes = [NSAttributedString.Key: Any]()
        scopes.updateAttributes(&attributes)
        
        let font = defaultFont(for: attributes)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = []
        paragraphStyle.defaultTabInterval = 2.em.asRawPoints(for: font.pointSize)
        scopes.updateParagraphStyle(paragraphStyle, with: font)

        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }
}

private extension StyleStack {
    func defaultFont(for attributes: [NSAttributedString.Key: Any]) -> NativeFont {
        (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
    }
}

extension StyleStack.Scope: ExpressibleAsAttributes {
    func updateAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        switch self {
        case let .blockStyles(styles):
            styles.updateAttributes(&attributes)
        case let .inlineStyles(styles):
            styles.updateAttributes(&attributes)
        }
    }
}

extension StyleStack.Scope: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle, with defaultFont: NativeFont) {
        switch self {
        case let .blockStyles(styles):
            return styles.updateParagraphStyle(paragraphStyle, with: defaultFont)
        case let .inlineStyles(styles):
            return styles.updateParagraphStyle(paragraphStyle, with: defaultFont)
        }
    }
}

extension Sequence where Element: ExpressibleAsAttributes {
    func updateAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        for style in self {
            style.updateAttributes(&attributes)
        }
    }
}

extension Sequence where Element: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle, with defaultFont: NativeFont) {
        for style in self {
            style.updateParagraphStyle(paragraphStyle, with: defaultFont)
        }
    }
}
