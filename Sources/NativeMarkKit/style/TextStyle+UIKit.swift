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
            return UIFont.systemFont(ofSize: size, weight: .medium)
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
                return FontDescriptor(name: .systemMonospace, size: .fixed(bodyFont.pointSize), traits: .monospace).makeFont()
            }
        case let .custom(name, size, traits):
            let descriptor = FontDescriptor(name: name, size: size, traits: traits)
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
        
    func withTraits(_ traits: FontTraits) -> UIFont {
        flatMap { $0.withTraits(traits) }
            ?? FontDescriptor(name: .system, size: .scaled(to: .body), traits: traits).makeFont()
    }
}

extension UIFont {
    func withTraits(_ traits: FontTraits) -> UIFont? {
        UIFont(descriptor: fontDescriptor.withTraits(traits), size: 0)
    }
}

private extension FontTraits {
    var symbolicTraits: UIFontDescriptor.SymbolicTraits {
        var traits: UIFontDescriptor.SymbolicTraits = []
        if contains(.italic) {
            traits.formUnion(.traitItalic)
        }
        if contains(.bold) {
            traits.formUnion(.traitBold)
        }
        if contains(.monospace) {
            traits.formUnion(.traitMonoSpace)
        }
        return traits
    }
}

private extension UIFontDescriptor {
    func withTraits(_ fontTraits: FontTraits) -> UIFontDescriptor {
        guard fontTraits != .unspecified else {
            return self
        }

        return withSymbolicTraits(symbolicTraits.union(fontTraits.symbolicTraits)) ?? self
    }
}

private extension FontDescriptor {
    func makeFont() -> UIFont {
        UIFont(descriptor: descriptor(), size: size.pointSize)
    }

    func descriptor() -> UIFontDescriptor {
        baseFontDescriptor().withTraits(traits)
    }
    
    func baseFontDescriptor() -> UIFontDescriptor {
        switch name {
        case .system:
            return UIFont.systemFont(ofSize: size.pointSize)
                .fontDescriptor
        case .systemMonospace:
            if #available(iOS 13.0, tvOS 13.0, *) {
                return UIFont.monospacedSystemFont(ofSize: size.pointSize, weight: .regular)
                    .fontDescriptor
            } else {
                let baseDescriptor = UIFont.systemFont(ofSize: size.pointSize)
                    .fontDescriptor
                    
                return baseDescriptor.withSymbolicTraits(.traitMonoSpace)
                    ?? baseDescriptor
            }
        case let .custom(fontName):
            return UIFontDescriptor(name: fontName, size: size.pointSize)
        }
    }
}

#endif
