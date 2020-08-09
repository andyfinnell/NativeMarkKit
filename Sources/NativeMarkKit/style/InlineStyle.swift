import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public enum InlineStyle {
    case textColor(NativeColor)
    case textStyle(TextStyle)
    case backgroundColor(NativeColor)
    case kerning(Length)
    case strikethrough(Strikethrough) // TODO: underline and strikethrough are a bit verbose in use
    case underline(Underline)
    case fontSize(CGFloat)
    case fontWeight(NativeFontWeight)
    case fontTraits(FontTraits)
    case backgroundBorder(width: CGFloat = 1, color: NativeColor = .adaptableBlockQuoteMarginColor, sides: BorderSides = .all)
    case inlineBackground(fillColor: NativeColor = .adaptableCodeBackgroundColor, strokeColor: NativeColor = .adaptableCodeBorderColor, strokeWidth: CGFloat = 1, cornerRadius: CGFloat = 3, topMargin: Length = 1.pt, bottomMargin: Length = 1.pt, leftMargin: Length = 6.pt, rightMargin: Length = 6.pt)
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
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            attributes[.kern] = kerning.asRawPoints(for: defaultFont.pointSize)
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
        case let .backgroundBorder(width: width, color: color, sides: sides):
            let backgroundBorder = BackgroundBorderValue(width: width, color: color, sides: sides)
            attributes[.backgroundBorder] = backgroundBorder
        case let .inlineBackground(fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth, cornerRadius: cornerRadius, topMargin: topMargin, bottomMargin: bottomMargin, leftMargin: leftMargin, rightMargin: rightMargin):
            let value = BackgroundValue(fillColor: fillColor,
                                              strokeColor: strokeColor,
                                              strokeWidth: strokeWidth,
                                              cornerRadius: cornerRadius,
                                              topMargin: topMargin,
                                              bottomMargin: bottomMargin,
                                              leftMargin: leftMargin,
                                              rightMargin: rightMargin)
            attributes[.inlineBackground] = value
        }
    }
}

