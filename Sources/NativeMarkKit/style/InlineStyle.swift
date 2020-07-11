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

struct Strikethrough {
    let style: NSUnderlineStyle
    let color: NativeColor?
}

struct Underline {
    let style: NSUnderlineStyle
    let color: NativeColor?
}

enum InlineStyle {
    case textColor(NativeColor)
    case textStyle(TextStyle)
    case backgroundColor(NativeColor)
    case kerning(Float)
    case strikethrough(Strikethrough)
    case superscript(Int)
    case underline(Underline)
}

extension InlineStyle: ExpressibleAsParagraphStyle {
    func updateParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) {
        // nop
    }
}

extension InlineStyle: ExpressibleAsAttributes {
    func attributes() -> [NSAttributedString.Key: Any] {
        switch self {
        case let .textColor(color):
            return [.foregroundColor: color]
        case let .textStyle(style):
            return [.font: makeFont(for: style)]
        case let .backgroundColor(backgroundColor):
            return [.backgroundColor: backgroundColor]
        case let .kerning(kerning):
            return [.kern: NSNumber(value: kerning)]
        case let .strikethrough(strikethrough):
            let color = strikethrough.color.map { [NSAttributedString.Key.strikethroughColor: $0] } ?? [:]
            return [.strikethroughStyle: NSNumber(value: strikethrough.style.rawValue)]
                .merging(color, uniquingKeysWith: { current, _ in current })
        case let .superscript(superscript):
            #if os(tvOS) || os(watchOS) || os(iOS)
            return [:]
            #else
            return [.superscript: NSNumber(value: superscript)]
            #endif
        case let .underline(underline):
            let color = underline.color.map { [NSAttributedString.Key.underlineColor: $0] } ?? [:]
            return [.underlineStyle: NSNumber(value: underline.style.rawValue)]
                .merging(color, uniquingKeysWith: { current, _ in current })
        }
    }
}

