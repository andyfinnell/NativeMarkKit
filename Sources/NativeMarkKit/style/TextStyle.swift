import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public enum FontName {
    case system
    case systemMonospace
    case custom(String)
}

public struct FontTraits: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let unspecified: FontTraits = []
    public static let italic = FontTraits(rawValue: 1 << 0)
    public static let bold = FontTraits(rawValue: 1 << 1)
    public static let monospace = FontTraits(rawValue: 1 << 2)
}

public enum FontSize {
    indirect case scaled(to: TextStyle)
    case fixed(CGFloat)
    
    var pointSize: CGFloat {
        switch self {
        case let .scaled(to: textStyle):
            return textStyle.pointSize
        case let .fixed(size):
            return size
        }
    }
}

public struct FontDescriptor {
    public let name: FontName
    public let size: FontSize
    public let traits: FontTraits
    
    public init(name: FontName, size: FontSize, traits: FontTraits) {
        self.name = name
        self.size = size
        self.traits = traits
    }
}

public enum TextStyle {
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
    case code
    case custom(name: FontName = .system, size: FontSize = .scaled(to: .body), traits: FontTraits = .unspecified)
}
