import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension NativeColor {
    #if canImport(UIKit)
    static var adaptableTextColor: NativeColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    static var adaptableBackgroundColor: NativeColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
        #if os(tvOS)
            return .groupTableViewBackground
        #else
            return .systemBackground
        #endif
        } else {
            return .white
        }
    }
    static var adaptableLinkColor: NativeColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return .link
        } else {
            return .systemBlue
        }
    }
    static var adaptableSeparatorColor: NativeColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return .opaqueSeparator
        } else {
            return NativeColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        }
    }
    #elseif canImport(AppKit)
    static var adaptableTextColor: NativeColor {
        .textColor
    }
    static var adaptableBackgroundColor: NativeColor {
        .textBackgroundColor
    }
    static var adaptableLinkColor: NativeColor {
        .linkColor
    }
    static var adaptableSeparatorColor: NativeColor {
        if #available(OSX 10.14, *) {
            return .separatorColor
        } else {
            return NativeColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        }
    }
    #endif

    static var adaptableBlockQuoteTextColor: NativeColor {
        makeAdaptiveColor(light: .blockQuoteText, dark: blockQuoteTextDark)
    }
    
    static var adaptableBlockQuoteMarginColor: NativeColor {
        makeAdaptiveColor(light: .lightGray, dark: .darkGray)
    }

    static var adaptableCodeBackgroundColor: NativeColor {
        makeAdaptiveColor(light: .codeBackground, dark: .codeBackgroundDark)
    }

    static var adaptableCodeBorderColor: NativeColor {
        makeAdaptiveColor(light: .lightGray, dark: .darkGray)
    }
    
    static var adaptableImagePlaceholderColor: NativeColor {
        makeAdaptiveColor(light: .imagePlaceholder, dark: .imagePlaceholderDark)
    }
}

private extension NativeColor {
    static let blockQuoteText = NativeColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    static let blockQuoteTextDark = NativeColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    static let codeBackground = NativeColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    static let codeBackgroundDark = NativeColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
    static let imagePlaceholder = NativeColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    static let imagePlaceholderDark = NativeColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)

    #if canImport(AppKit)
    static func makeAdaptiveColor(_ name: String = #function, light: NativeColor, dark: NativeColor) -> NativeColor {
        if #available(OSX 10.15, *) {
            return NativeColor(name: Name(name), dynamicProvider: { appearance in
                if appearance.name == .darkAqua {
                    return dark
                } else {
                    return light
                }
            })
        } else {
            return light
        }
    }
    #elseif canImport(UIKit)
    static func makeAdaptiveColor(light: NativeColor, dark: NativeColor) -> NativeColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return UIColor(dynamicProvider: { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    return light
                case .dark:
                    return dark
                @unknown default:
                    return light
                }
            })
        } else {
            return light
        }
    }
    #endif
}
