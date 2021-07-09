import Foundation

#if canImport(AppKit)
import AppKit

extension TextStyle {
    func makeFont() -> NSFont {
        switch self {
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
        case .code:
            if #available(OSX 10.15, *) {
                return NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
            } else {
                return FontDescriptor(name: .systemMonospace, size: .fixed(12), traits: .monospace).makeFont()
            }
        case let .custom(name, size, traits):
            let descriptor = FontDescriptor(name: name, size: size, traits: traits)
            return descriptor.makeFont()
        }
    }
    
    var pointSize: CGFloat { makeFont().pointSize }
}

extension Optional where Wrapped == NSFont {
    func withSize(_ size: CGFloat) -> NSFont {
        flatMap { $0.withSize(size) } ?? NSFont.systemFont(ofSize: size)
    }
        
    func withTraits(_ traits: FontTraits) -> NSFont {
        flatMap { $0.withTraits(traits) }
            ?? FontDescriptor(name: .system, size: .fixed(12), traits: traits).makeFont()
    }
}

extension NSFont {
    func withSize(_ size: CGFloat) -> NSFont? {
        NSFont(descriptor: fontDescriptor.withSize(size), textTransform: nil)
    }
        
    func withTraits(_ traits: FontTraits) -> NSFont? {
        NSFont(descriptor: fontDescriptor.withTraits(traits), textTransform: nil)
    }
}

private extension FontTraits {
    var symbolicTraits: NSFontDescriptor.SymbolicTraits {
        var traits: NSFontDescriptor.SymbolicTraits = []
        if contains(.italic) {
            traits.formUnion(.italic)
        }
        if contains(.bold) {
            traits.formUnion(.bold)
        }
        if contains(.monospace) {
            traits.formUnion(.monoSpace)
        }
        return traits
    }
}

private extension NSFontDescriptor {
    func withTraits(_ fontTraits: FontTraits) -> NSFontDescriptor {
        guard fontTraits != .unspecified else {
            return self
        }
        return withSymbolicTraits(symbolicTraits.union(fontTraits.symbolicTraits))
    }
}

private extension FontDescriptor {
    func makeFont() -> NSFont {
        NSFont(descriptor: descriptor(), textTransform: nil)
            ?? NSFont.systemFont(ofSize: size.pointSize)
    }
    
    func descriptor() -> NSFontDescriptor {
        baseFontDescriptor().withTraits(traits)
    }
    
    func baseFontDescriptor() -> NSFontDescriptor {
        switch name {
        case .system:
            return NSFont.systemFont(ofSize: size.pointSize)
                .fontDescriptor
        case .systemMonospace:
            if #available(OSX 10.15, *) {
                return NSFont.monospacedSystemFont(ofSize: size.pointSize, weight: .regular)
                    .fontDescriptor
            } else {
                return NSFont.systemFont(ofSize: size.pointSize)
                    .fontDescriptor
                    .withSymbolicTraits(.monoSpace)
            }
        case let .custom(fontName):
            return NSFontDescriptor(name: fontName, size: size.pointSize)
        }
    }
}

#endif
