import Foundation
#if canImport(AppKit)
import AppKit

extension NSFont {
    var cgFont: CGFont? {
        let postscriptName = fontDescriptor.postscriptName ?? fontName
        return CGFont(postscriptName as CFString)
    }
}

#elseif canImport(UIKit)
import UIKit

extension UIFont {
    var cgFont: CGFont? {
        CGFont(fontDescriptor.postscriptName as CFString)
    }
}

#endif
