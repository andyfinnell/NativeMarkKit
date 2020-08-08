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
    fileprivate struct Scope {
        let blockStyles: [BlockStyle]
        let inlineStyles: [InlineStyle]
        let rawAttributes: [NSAttributedString.Key: Any]
    }
    private var scopes = [Scope]()
    let stylesheet: StyleSheet
    
    init(stylesheet: StyleSheet) {
        self.stylesheet = stylesheet
    }
    
    func push(_ blockSelector: BlockStyleSelector, rawAttributes: [NSAttributedString.Key: Any] = [:]) {
        let scope = Scope(blockStyles: stylesheet.styles(for: blockSelector),
                          inlineStyles: [],
                          rawAttributes: rawAttributes)
        scopes.append(scope)
    }
    
    func push(_ inlineSelector: InlineStyleSelector, rawAttributes: [NSAttributedString.Key: Any] = [:]) {
        let scope = Scope(blockStyles: [],
                          inlineStyles: stylesheet.styles(for: inlineSelector),
                          rawAttributes: rawAttributes)
        scopes.append(scope)
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
        blockStyles.updateAttributes(&attributes)
        inlineStyles.updateAttributes(&attributes)
        attributes.merge(rawAttributes, uniquingKeysWith: { _, new in new })
    }
}

extension StyleStack.Scope: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle, with defaultFont: NativeFont) {
        blockStyles.updateParagraphStyle(paragraphStyle, with: defaultFont)
        inlineStyles.updateParagraphStyle(paragraphStyle, with: defaultFont)
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
