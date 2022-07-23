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
    case backgroundColor(NativeColor?)
    case kerning(Length)
    case strikethrough(NSUnderlineStyle, color: NativeColor? = nil)
    case underline(NSUnderlineStyle, color: NativeColor? = nil)
    case fontSize(CGFloat)
    case fontTraits(FontTraits)
    case inlineBackground(margin: Margin = .zero,
                          border: Border = Border(shape: .roundedRect(cornerRadius: 3), width: 1, color: .adaptableCodeBorderColor),
                          padding: Padding = Padding(left: 5.pt, right: 5.pt, top: 0.pt, bottom: 0.pt),
                          backgroundColor: NativeColor? = .adaptableCodeBackgroundColor)
    

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
        case let .strikethrough(style, color: color):
            if let color = color {
                attributes[.strikethroughColor] = color
            }
            attributes[.strikethroughStyle] = NSNumber(value: style.rawValue)
        case let .underline(style, color: color):
            if let color = color {
                attributes[.underlineColor] = color
            }
            attributes[.underlineStyle] = NSNumber(value: style.rawValue)
        case let .fontSize(fontSize):
            let currentFont = attributes[.font] as? NativeFont
            attributes[.font] = currentFont.withSize(fontSize)
        case let .fontTraits(traits):
            let currentFont = attributes[.font] as? NativeFont
            attributes[.font] = currentFont.withTraits(traits)
        case let .inlineBackground(margin: margin, border: border, padding: padding, backgroundColor: backgroundColor):
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            let style = TextContainerStyle(margin: margin.asRawPoints(for: defaultFont.pointSize),
                                           border: border,
                                           padding: padding.asRawPoints(for: defaultFont.pointSize),
                                           backgroundColor: backgroundColor)
            attributes[.inlineBackground] = InlineContainerStyleValue(style: style)
        }
    }
}

