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
    case orderedListMarker(OrderedListMarkerFormat, prefix: String = "", suffix: String = ".")
    case unorderedListMarker(UnorderedListMarkerFormat)
    case thematicBreak(thickness: CGFloat, color: NativeColor = .adaptableSeparatorColor)
    case blockQuote(padding: Padding = Padding(left: 2.em, right: 1.em), borderWidth: CGFloat = 8, borderColor: NativeColor = .adaptableBlockQuoteMarginColor, borderSides: BorderSides = .left)
    case list(padding: Padding = Padding(left: 0.5.em), markerToContentIndent: Length = 1.5.em, paragraphSpacingBefore: Length = 0.5.em, paragraphSpacingAfter: Length = 0.5.em)
    case blockBackground(fillColor: NativeColor = .adaptableCodeBackgroundColor, strokeColor: NativeColor = .adaptableCodeBorderColor, strokeWidth: CGFloat = 1, cornerRadius: CGFloat = 3, topMargin: Length = 1.em, bottomMargin: Length = 1.em, leftMargin: Length = 1.em, rightMargin: Length = 1.em)
    case inlineStyle(InlineStyle)
}

public extension BlockStyle {
    static func textColor(_ value: NativeColor) -> BlockStyle {
        .inlineStyle(.textColor(value))
    }
    
    static func textStyle(_ value: TextStyle) -> BlockStyle {
        .inlineStyle(.textStyle(value))
    }
        
    static func backgroundColor(_ value: NativeColor?) -> BlockStyle {
        .inlineStyle(.backgroundColor(value))
    }
    
    static func kerning(_ value: Length) -> BlockStyle {
        .inlineStyle(.kerning(value))
    }
    
    static func strikethrough(_ style: NSUnderlineStyle, color: NativeColor? = nil) -> BlockStyle {
        .inlineStyle(.strikethrough(style, color: color))
    }
        
    static func underline(_ style: NSUnderlineStyle, color: NativeColor? = nil) -> BlockStyle {
        .inlineStyle(.underline(style, color: color))
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
                .blockBackground, .blockQuote, .list:
            break // handled elsewhere
        }
    }
}

extension BlockStyle: ExpressibleAsAttributes {
    func updateAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        switch self {
        case let .inlineStyle(style):
            style.updateAttributes(&attributes)
        case let .orderedListMarker(format, prefix: prefix, suffix: suffix):
            attributes[.orderedListMarkerFormat] = OrderedListMarkerFormatValue(format: format, prefix: prefix, suffix: suffix)
        case let .unorderedListMarker(format):
            attributes[.unorderedListMarkerFormat] = UnorderedListMarkerFormatValue(format: format)
        case let .thematicBreak(thickness: thickness, color: color):
            attributes[.thematicBreakThickness] = thickness
            attributes[.thematicBreakColor] = color
        case let .blockBackground(fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth, cornerRadius: cornerRadius, topMargin: topMargin, bottomMargin: bottomMargin, leftMargin: leftMargin, rightMargin: rightMargin):
            let value = BackgroundValue(fillColor: fillColor,
                                             strokeColor: strokeColor,
                                             strokeWidth: strokeWidth,
                                             cornerRadius: cornerRadius,
                                             topMargin: topMargin,
                                             bottomMargin: bottomMargin,
                                             leftMargin: leftMargin,
                                             rightMargin: rightMargin)
            attributes[.blockBackground] = value
        case let .blockQuote(padding: padding, borderWidth: borderWidth, borderColor: borderColor, borderSides: borderSides):
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            let value = BlockQuoteValue(leftPadding: padding.left.asRawPoints(for: defaultFont.pointSize),
                                        rightPadding: padding.right.asRawPoints(for: defaultFont.pointSize),
                                        topPadding: padding.top.asRawPoints(for: defaultFont.pointSize),
                                        bottomPadding: padding.bottom.asRawPoints(for: defaultFont.pointSize),
                                        borderWidth: borderWidth,
                                        borderColor: borderColor,
                                        borderSides: borderSides)
            attributes[.blockQuote] = value
        case let .list(padding: padding, markerToContentIndent: markerToContentIndent, paragraphSpacingBefore: paragraphSpacingBefore, paragraphSpacingAfter: paragraphSpacingAfter):
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            let value = ListValue(leftPadding: padding.left.asRawPoints(for: defaultFont.pointSize),
                                  rightPadding: padding.right.asRawPoints(for: defaultFont.pointSize),
                                  topPadding: padding.top.asRawPoints(for: defaultFont.pointSize),
                                  bottomPadding: padding.bottom.asRawPoints(for: defaultFont.pointSize),
                                  markerToContentIndent: markerToContentIndent.asRawPoints(for: defaultFont.pointSize),
                                  paragraphSpacingBefore: paragraphSpacingBefore.asRawPoints(for: defaultFont.pointSize),
                                  paragraphSpacingAfter: paragraphSpacingAfter.asRawPoints(for: defaultFont.pointSize))
            attributes[.list] = value
        default:
            break
        }
    }
}
