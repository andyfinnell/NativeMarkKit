import Foundation
#if canImport(UIKit)
import UIKit

extension NativeImage {
    static func make(size: CGSize, draw: () -> Void) -> NativeImage {
        UIGraphicsBeginImageContext(size.validImageSize)
        draw()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

private extension CGSize {
    var validImageSize: CGSize {
        CGSize(width: max(1, width), height: max(1, height))
    }
}

#elseif canImport(AppKit)
import AppKit

extension NativeImage {
    static func make(size: CGSize, draw: () -> Void) -> NativeImage {
        let image = NSImage(size: size)
        image.lockFocusFlipped(true)
        draw()
        image.unlockFocus()
        return image
    }
}

#else
#error("Unsupported platform")
#endif
