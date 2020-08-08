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

public enum FontTraits {
    case unspecified
    case italic
    case monospace
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
    public let weight: NativeFontWeight
    public let traits: FontTraits
    
    public init(name: FontName, size: FontSize, weight: NativeFontWeight, traits: FontTraits) {
        self.name = name
        self.size = size
        self.weight = weight
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
    case custom(FontDescriptor)
}
