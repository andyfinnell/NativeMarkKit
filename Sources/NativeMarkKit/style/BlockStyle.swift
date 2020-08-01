import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public enum BlockStyle {
    case alignment(NSTextAlignment)
    case firstLineHeadIndent(Length)
    case headIndent(Length)
    case tailIndent(Length)
    case lineHeightMultiple(CGFloat)
    case lineSpacing(Length)
    case paragraphSpacingAfter(Length)
    case paragraphSpacingBefore(Length)
    case lineBreak(NSLineBreakMode)
    case orderedListMarker(OrderedListMarkerFormat, separator: String)
    case unorderedListMarker(UnorderedListMarkerFormat)
    case thematicBreak(thickness: CGFloat, color: NativeColor)
    case blockBackground(fillColor: NativeColor = .backgroundGray, strokeColor: NativeColor = .veryLightGray, strokeWidth: CGFloat = 1, cornerRadius: CGFloat = 3, topMargin: Length = 1.em, bottomMargin: Length = 1.em, leftMargin: Length = 1.em, rightMargin: Length = 1.em)
    case inlineStyle(InlineStyle)
}

public extension BlockStyle {
    static func textColor(_ value: NativeColor) -> BlockStyle {
        .inlineStyle(.textColor(value))
    }
    
    static func textStyle(_ value: TextStyle) -> BlockStyle {
        .inlineStyle(.textStyle(value))
    }
        
    static func backgroundColor(_ value: NativeColor) -> BlockStyle {
        .inlineStyle(.backgroundColor(value))
    }
    
    static func kerning(_ value: Length) -> BlockStyle {
        .inlineStyle(.kerning(value))
    }
    
    static func strikethrough(_ value: Strikethrough) -> BlockStyle {
        .inlineStyle(.strikethrough(value))
    }
        
    static func underline(_ value: Underline) -> BlockStyle {
        .inlineStyle(.underline(value))
    }
    
    static func backgroundBorder(width: CGFloat = 1, color: NativeColor = .lightGray, sides: BorderSides = .all) -> BlockStyle {
        .inlineStyle(.backgroundBorder(width: width, color: color, sides: sides))
    }
}

extension BlockStyle: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle, with defaultFont: NativeFont) {
        switch self {
        case let .alignment(alignment):
            paragraphStyle.alignment = alignment
        case let .firstLineHeadIndent(indent):
            paragraphStyle.firstLineHeadIndent = indent.asRawPoints(for: defaultFont.pointSize)
        case let .headIndent(indent):
            paragraphStyle.headIndent = indent.asRawPoints(for: defaultFont.pointSize)
        case let .tailIndent(indent):
            paragraphStyle.tailIndent = indent.asRawPoints(for: defaultFont.pointSize)
        case let .lineHeightMultiple(multiple):
            paragraphStyle.lineHeightMultiple = multiple
        case let .lineSpacing(spacing):
            paragraphStyle.lineSpacing = spacing.asRawPoints(for: defaultFont.pointSize)
        case let .paragraphSpacingAfter(spacing):
            paragraphStyle.paragraphSpacing = spacing.asRawPoints(for: defaultFont.pointSize)
        case let .paragraphSpacingBefore(spacing):
            paragraphStyle.paragraphSpacingBefore = spacing.asRawPoints(for: defaultFont.pointSize)
        case let .lineBreak(lineBreak):
            paragraphStyle.lineBreakMode = lineBreak
        case .inlineStyle, .orderedListMarker, .unorderedListMarker, .thematicBreak,
             .blockBackground:
            break // handled elsewhere
        }
    }
}

extension BlockStyle: ExpressibleAsAttributes {
    func updateAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        switch self {
        case let .inlineStyle(style):
            style.updateAttributes(&attributes)
        case let .orderedListMarker(format, separator: separator):
            attributes[.orderedListMarkerFormat] = OrderedListMarkerFormatValue(format: format, separator: separator)
        case let .unorderedListMarker(format):
            attributes[.unorderedListMarkerFormat] = UnorderedListMarkerFormatValue(format: format)
        case let .thematicBreak(thickness: thickness, color: color):
            attributes[.thematicBreakThickness] = thickness
            attributes[.thematicBreakColor] = color
        case let .blockBackground(fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth, cornerRadius: cornerRadius, topMargin: topMargin, bottomMargin: bottomMargin, leftMargin: leftMargin, rightMargin: rightMargin):
            let value = BlockBackgroundValue(fillColor: fillColor,
                                             strokeColor: strokeColor,
                                             strokeWidth: strokeWidth,
                                             cornerRadius: cornerRadius,
                                             topMargin: topMargin,
                                             bottomMargin: bottomMargin,
                                             leftMargin: leftMargin,
                                             rightMargin: rightMargin)
            attributes[.blockBackground] = value
        default:
            break
        }
    }
}
