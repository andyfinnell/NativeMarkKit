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

enum FontName {
    case system
    case custom(String)
}

struct FontDescriptor {
    let name: FontName
    let size: CGFloat
}

enum TextStyle {
    case body
    case callout
    case caption1
    case caption2
    case footnote
    case headline
    case subheadline
    case largeTitle
    case title1
    case title2
    case title3
    case custom(FontDescriptor)
}

#if canImport(AppKit)

func makeFont(for textStyle: TextStyle) -> NSFont {
    switch textStyle {
    case .body:
        return NSFont.systemFont(ofSize: 12)
    case .callout:
        return NSFont.systemFont(ofSize: 11)
    case .caption1:
        return NSFont.systemFont(ofSize: 9)
    case .caption2:
        return NSFont.systemFont(ofSize: 8)
    case .footnote:
        return NSFont.systemFont(ofSize: 10)
    case .headline:
        return NSFont.boldSystemFont(ofSize: 12)
    case .subheadline:
        return NSFont.systemFont(ofSize: 11)
    case .largeTitle:
        return NSFont.systemFont(ofSize: 24)
    case .title1:
        return NSFont.systemFont(ofSize: 21)
    case .title2:
        return NSFont.systemFont(ofSize: 17)
    case .title3:
        return NSFont.systemFont(ofSize: 14)
    case let .custom(descriptor):
        return makeFont(for: descriptor)
    }
}

fileprivate func makeFont(for descriptor: FontDescriptor) -> NSFont {
    switch descriptor.name {
    case .system:
        return NSFont.systemFont(ofSize: descriptor.size)
    case let .custom(fontName):
        return NSFont(name: fontName, size: descriptor.size)
            ?? NSFont.systemFont(ofSize: descriptor.size)
    }
}

#elseif canImport(UIKit)

func makeFont(for textStyle: TextStyle) -> UIFont {
    switch textStyle {
    case .body:
        return UIFont.preferredFont(forTextStyle: .body)
    case .callout:
        if #available(iOS 9.0, *) {
            return UIFont.preferredFont(forTextStyle: .callout)
        } else {
            return UIFont.systemFont(ofSize: 16)
        }
    case .caption1:
        return UIFont.preferredFont(forTextStyle: .caption1)
    case .caption2:
        return UIFont.preferredFont(forTextStyle: .caption2)
    case .footnote:
        return UIFont.preferredFont(forTextStyle: .footnote)
    case .headline:
        return UIFont.preferredFont(forTextStyle: .headline)
    case .subheadline:
        return UIFont.preferredFont(forTextStyle: .subheadline)
    case .largeTitle:
        #if os(tvOS)
        return UIFont.systemFont(ofSize: 34)
        #else
        if #available(iOS 11.0, watchOS 5.0, *) {
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        } else {
            return UIFont.systemFont(ofSize: 34)
        }
        #endif
    case .title1:
        if #available(iOS 9.0, *) {
            return UIFont.preferredFont(forTextStyle: .title1)
        } else {
            return UIFont.systemFont(ofSize: 28)
        }
    case .title2:
        if #available(iOS 9.0, *) {
            return UIFont.preferredFont(forTextStyle: .title2)
        } else {
            return UIFont.systemFont(ofSize: 22)
        }
    case .title3:
        if #available(iOS 9.0, *) {
            return UIFont.preferredFont(forTextStyle: .title3)
        } else {
            return UIFont.systemFont(ofSize: 20)
        }
    case let .custom(descriptor):
        return makeFont(for: descriptor)
    }
}

fileprivate func makeFont(for descriptor: FontDescriptor) -> UIFont {
    switch descriptor.name {
    case .system:
        return UIFont.systemFont(ofSize: descriptor.size)
    case let .custom(fontName):
        return UIFont(descriptor: UIFontDescriptor(name: fontName, size: descriptor.size),
                      size: descriptor.size)
    }
}

#else
#error("Unsupported platform")
#endif
