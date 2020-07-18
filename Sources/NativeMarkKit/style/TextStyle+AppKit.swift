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
        case let .custom(descriptor):
            return descriptor.makeFont()
        }
    }
}

extension Optional where Wrapped == NSFont {
    func withSize(_ size: CGFloat) -> NSFont {
        flatMap { $0.withSize(size) } ?? NSFont.systemFont(ofSize: size)
    }
    
    func withWeight(_ weight: NSFont.Weight) -> NSFont {
        flatMap { $0.withWeight(weight) }
            ?? FontDescriptor(name: .system, size: 17, weight: weight, traits: .unspecified).makeFont()
    }
    
    func withTraits(_ traits: FontTraits) -> NSFont {
        flatMap { $0.withTraits(traits) }
            ?? FontDescriptor(name: .system, size: 17, weight: .regular, traits: traits).makeFont()
    }
}

extension NSFont {
    func withSize(_ size: CGFloat) -> NSFont? {
        NSFont(descriptor: fontDescriptor.withSize(size), textTransform: nil)
    }
    
    func withWeight(_ weight: NSFont.Weight) -> NSFont? {
        NSFont(descriptor: fontDescriptor.withWeight(weight), textTransform: nil)
    }
    
    func withTraits(_ traits: FontTraits) -> NSFont? {
        NSFont(descriptor: fontDescriptor.withTraits(traits), textTransform: nil)
    }
}

private extension FontTraits {
    var symbolicTraits: NSFontDescriptor.SymbolicTraits {
        switch self {
        case .italic:
            return [.italic]
        case .monospace:
            return [.monoSpace]
        case .unspecified:
            return []
        }
    }
    
    func updateTraits(_ traits: inout [NSFontDescriptor.TraitKey: Any]) {
        let currentRawValue = traits[.symbolic] as? UInt32 ?? 0
        let current = NSFontDescriptor.SymbolicTraits(rawValue: currentRawValue)
        traits[.symbolic] = current.union(symbolicTraits).rawValue
    }
}

private extension NSFontDescriptor {
    func withWeight(_ weight: NSFont.Weight) -> NSFontDescriptor {
        var attributes = fontAttributes
        var traits = (attributes[.traits] as? [NSFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        attributes[.traits] = traits
        return NSFontDescriptor(fontAttributes: attributes)
    }
    
    func withTraits(_ fontTraits: FontTraits) -> NSFontDescriptor {
        var attributes = fontAttributes
        var traits = (attributes[.traits] as? [NSFontDescriptor.TraitKey: Any]) ?? [:]
        fontTraits.updateTraits(&traits)
        attributes[.traits] = traits
        return NSFontDescriptor(fontAttributes: attributes)
    }
}

private extension FontDescriptor {
    func makeFont() -> NSFont {
        NSFont(descriptor: descriptor(), textTransform: nil)
            ?? NSFont.systemFont(ofSize: size)
    }
    
    func descriptor() -> NSFontDescriptor {
        var attributes = baseAttributes()
        var traits = (attributes[.traits] as? [NSFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        self.traits.updateTraits(&traits)
        attributes[.traits] = traits
        attributes[.size] = size
        return NSFontDescriptor(fontAttributes: attributes)
    }
    
    func baseAttributes() -> [NSFontDescriptor.AttributeName: Any] {
        switch name {
        case .system:
            return NSFont.systemFont(ofSize: size)
                .fontDescriptor
                .fontAttributes
        case .systemMonospace:
            if #available(OSX 10.15, *) {
                return NSFont.monospacedSystemFont(ofSize: size, weight: weight)
                    .fontDescriptor
                    .fontAttributes
            } else {
                let traits: [NSFontDescriptor.TraitKey: Any] = [
                    .symbolic: NSFontMonoSpaceTrait
                ]
                return [.traits: traits]
            }
        case let .custom(fontName):
            return [.name: fontName]
        }
    }
}

#endif
