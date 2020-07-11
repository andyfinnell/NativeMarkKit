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

enum BlockStyle {
    case alignment(NSTextAlignment)
    case firstLineHeadIndent(CGFloat)
    case headIndent(CGFloat)
    case tailIndent(CGFloat)
    case lineHeightMultiple(CGFloat)
    case lineSpacing(CGFloat)
    case paragraphSpacingAfter(CGFloat)
    case paragraphSpacingBefore(CGFloat)
    case lineBreak(NSLineBreakMode)
    case inlineStyle(InlineStyle)
}

extension BlockStyle {
    static func textColor(_ value: NativeColor) -> BlockStyle {
        .inlineStyle(.textColor(value))
    }
    
    static func textStyle(_ value: TextStyle) -> BlockStyle {
        .inlineStyle(.textStyle(value))
    }
        
    static func backgroundColor(_ value: NativeColor) -> BlockStyle {
        .inlineStyle(.backgroundColor(value))
    }
    
    static func kerning(_ value: Float) -> BlockStyle {
        .inlineStyle(.kerning(value))
    }
    
    static func strikethrough(_ value: Strikethrough) -> BlockStyle {
        .inlineStyle(.strikethrough(value))
    }
    
    static func superscript(_ value: Int) -> BlockStyle {
        .inlineStyle(.superscript(value))
    }
    
    static func underline(_ value: Underline) -> BlockStyle {
        .inlineStyle(.underline(value))
    }
}

extension BlockStyle: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) {
        switch self {
        case let .alignment(alignment):
            paragraphStyle.alignment = alignment
        case let .firstLineHeadIndent(indent):
            paragraphStyle.firstLineHeadIndent = indent
        case let .headIndent(indent):
            paragraphStyle.headIndent = indent
        case let .tailIndent(indent):
            paragraphStyle.tailIndent = indent
        case let .lineHeightMultiple(multiple):
            paragraphStyle.lineHeightMultiple = multiple
        case let .lineSpacing(spacing):
            paragraphStyle.lineSpacing = spacing
        case let .paragraphSpacingAfter(spacing):
            paragraphStyle.paragraphSpacing = spacing
        case let .paragraphSpacingBefore(spacing):
            paragraphStyle.paragraphSpacingBefore = spacing
        case let .lineBreak(lineBreak):
            paragraphStyle.lineBreakMode = lineBreak
        case .inlineStyle:
            break // handled elsewhere
        }
    }
}

extension BlockStyle: ExpressibleAsAttributes {
    func attributes() -> [NSAttributedString.Key: Any] {
        if case let .inlineStyle(style) = self {
            return style.attributes()
        } else {
            return [:]
        }
    }
}
