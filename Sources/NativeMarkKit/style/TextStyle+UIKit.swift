import Foundation

#if canImport(UIKit)
import UIKit

extension TextStyle {
    func makeFont() -> UIFont {
        switch self {
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
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
            let title1Font = UIFont.preferredFont(forTextStyle: .title1)
            let size = (title1Font.pointSize * 92.0 / 76.0).rounded()
            let baseFont = UIFont.systemFont(ofSize: size)
            return baseFont.withWeight(.medium) ?? baseFont
            #else
            if #available(iOS 11.0, watchOS 5.0, *) {
                return UIFont.preferredFont(forTextStyle: .largeTitle)
            } else {
                let title1Font = UIFont.preferredFont(forTextStyle: .title1)
                let size = (title1Font.pointSize * 34.0 / 28.0).rounded()
                return UIFont.systemFont(ofSize: size)
            }
            #endif
        case .title1:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .code:
            let bodyFont = UIFont.preferredFont(forTextStyle: .body)
            if #available(iOS 13.0, tvOS 13.0, *) {
                return UIFont.monospacedSystemFont(ofSize: bodyFont.pointSize, weight: .regular)
            } else {
                return FontDescriptor(name: .systemMonospace, size: .fixed(bodyFont.pointSize), weight: .regular, traits: .monospace).makeFont()
            }
        case let .custom(name, size, weight, traits):
            let descriptor = FontDescriptor(name: name, size: size, weight: weight, traits: traits)
            return descriptor.makeFont()
        }
    }
    
    var pointSize: CGFloat {
        makeFont().pointSize
    }
}

extension Optional where Wrapped == UIFont {
    func withSize(_ size: CGFloat) -> UIFont {
        flatMap { $0.withSize(size) } ?? UIFont.systemFont(ofSize: size)
    }
    
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        flatMap { $0.withWeight(weight) }
            ?? FontDescriptor(name: .system, size: .scaled(to: .body), weight: weight, traits: .unspecified).makeFont()
    }
    
    func withTraits(_ traits: FontTraits) -> UIFont {
        flatMap { $0.withTraits(traits) }
            ?? FontDescriptor(name: .system, size: .scaled(to: .body), weight: .regular, traits: traits).makeFont()
    }
}

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont? {
        UIFont(descriptor: fontDescriptor.withWeight(weight), size: pointSize)
    }
    
    func withTraits(_ traits: FontTraits) -> UIFont? {
        UIFont(descriptor: fontDescriptor.withTraits(traits), size: pointSize)
    }
}

private extension FontTraits {
    var symbolicTraits: UIFontDescriptor.SymbolicTraits {
        switch self {
        case .italic:
            return [.traitItalic]
        case .monospace:
            return [.traitMonoSpace]
        case .unspecified:
            return []
        }
    }
    
    func updateTraits(_ traits: inout [UIFontDescriptor.TraitKey: Any]) {
        let currentRawValue = traits[.symbolic] as? UInt32 ?? 0
        let current = UIFontDescriptor.SymbolicTraits(rawValue: currentRawValue)
        traits[.symbolic] = current.union(symbolicTraits).rawValue
    }
}

private extension UIFontDescriptor {
    func withWeight(_ weight: UIFont.Weight) -> UIFontDescriptor {
        var attributes = fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        attributes[.traits] = traits
        return UIFontDescriptor(fontAttributes: attributes)
    }
    
    func withTraits(_ fontTraits: FontTraits) -> UIFontDescriptor {
        var attributes = fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        fontTraits.updateTraits(&traits)
        attributes[.traits] = traits
        return UIFontDescriptor(fontAttributes: attributes)
    }
}

private extension FontDescriptor {
    func makeFont() -> UIFont {
        UIFont(descriptor: descriptor(), size: size.pointSize)
    }

    func descriptor() -> UIFontDescriptor {
        var attributes = baseAttributes()
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        self.traits.updateTraits(&traits)
        attributes[.traits] = traits
        attributes[.size] = size.pointSize
        return UIFontDescriptor(fontAttributes: attributes)
    }
    
    func baseAttributes() -> [UIFontDescriptor.AttributeName: Any] {
        switch name {
        case .system:
            return UIFont.systemFont(ofSize: size.pointSize)
                .fontDescriptor
                .fontAttributes
        case .systemMonospace:
            if #available(iOS 13.0, tvOS 13.0, *) {
                return UIFont.monospacedSystemFont(ofSize: size.pointSize, weight: weight)
                    .fontDescriptor
                    .fontAttributes
            } else {
                let traits: [UIFontDescriptor.TraitKey: Any] = [
                    .symbolic: UIFontDescriptor.SymbolicTraits.traitMonoSpace.rawValue
                ]
                return [.traits: traits]
            }
        case let .custom(fontName):
            return [.name: fontName]
        }
    }
}

#endif
