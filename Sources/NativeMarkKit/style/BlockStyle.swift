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
    case blockBorder(Border = Border(shape: .rectangle(sides: .all), width: 1, color: .adaptableCodeBorderColor))
    case blockMargin(Margin)
    case blockPadding(Padding)
    case blockBackground(NativeColor?)
    case list(markerToContentIndent: Length = 1.5.em)
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
        case .inlineStyle, .orderedListMarker, .unorderedListMarker, .thematicBreak, .list, .blockBorder, .blockMargin,
                .blockPadding, .blockBackground:
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
        case let .list(markerToContentIndent: markerToContentIndent):
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            let value = ListValue(markerToContentIndent: markerToContentIndent.asRawPoints(for: defaultFont.pointSize))
            attributes[.list] = value
        
        case let .blockBorder(border):
            attributes[.blockBorder] = BorderValue(border: border)
        case let .blockMargin(margin):
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            attributes[.blockMargin] = MarginValue(margin: margin.asRawPoints(for: defaultFont.pointSize))
        case let .blockPadding(padding):
            let defaultFont = (attributes[.font] as? NativeFont) ?? TextStyle.body.makeFont()
            attributes[.blockPadding] = PaddingValue(padding: padding.asRawPoints(for: defaultFont.pointSize))
        case let .blockBackground(color):
            attributes[.blockBackground] = color
            
        case .alignment,
         .firstLineHeadIndent,
         .headIndent,
         .tailIndent,
         .lineHeightMultiple,
         .lineSpacing,
         .paragraphSpacingAfter,
         .paragraphSpacingBefore,
        .lineBreak:
            break
        }
    }
}
