import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct Strikethrough {
    public let style: NSUnderlineStyle
    public let color: NativeColor?
    
    public init(style: NSUnderlineStyle, color: NativeColor?) {
        self.style = style
        self.color = color
    }
}

public struct Underline {
    public let style: NSUnderlineStyle
    public let color: NativeColor?
    
    public init(style: NSUnderlineStyle, color: NativeColor?) {
        self.style = style
        self.color = color
    }
}

public enum InlineStyle {
    case textColor(NativeColor) // TODO: what about dark mode?
    case textStyle(TextStyle)
    case backgroundColor(NativeColor)
    case kerning(Float)
    case strikethrough(Strikethrough)
    case underline(Underline)
    case fontSize(CGFloat)
    case fontWeight(NativeFontWeight)
    case fontTraits(FontTraits)
}

extension InlineStyle: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle, with defaultFont: NativeFont) {
        // nop
    }
}

extension InlineStyle: ExpressibleAsAttributes {
    func updateAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        switch self {
        case let .textColor(color):
            attributes[.foregroundColor] = color
        case let .textStyle(style):
            attributes[.font] = style.makeFont()
        case let .backgroundColor(backgroundColor):
            attributes[.backgroundColor] = backgroundColor
        case let .kerning(kerning):
            attributes[.kern] = NSNumber(value: kerning)
        case let .strikethrough(strikethrough):
            if let color = strikethrough.color {
                attributes[.strikethroughColor] = color
            }
            attributes[.strikethroughStyle] = NSNumber(value: strikethrough.style.rawValue)
        case let .underline(underline):
            if let color = underline.color {
                attributes[.underlineColor] = color
            }
            attributes[.underlineStyle] = NSNumber(value: underline.style.rawValue)
        case let .fontSize(fontSize):
            let currentFont = attributes[.font] as? NativeFont
            attributes[.font] = currentFont.withSize(fontSize)
        case let .fontWeight(weight):
            let currentFont = attributes[.font] as? NativeFont
            attributes[.font] = currentFont.withWeight(weight)
        case let .fontTraits(traits):
            let currentFont = attributes[.font] as? NativeFont
            attributes[.font] = currentFont.withTraits(traits)
        }
    }
}

