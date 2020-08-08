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

public struct FontDescriptor {
    public let name: FontName
    public let size: CGFloat // TODO: should provide sizes that can be scaled relative for the platform
    public let weight: NativeFontWeight
    public let traits: FontTraits
    
    public init(name: FontName, size: CGFloat, weight: NativeFontWeight, traits: FontTraits) {
        self.name = name
        self.size = size
        self.weight = weight
        self.traits = traits
    }
}

// TODO: should exercise all these styles to make sure they look fine
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
