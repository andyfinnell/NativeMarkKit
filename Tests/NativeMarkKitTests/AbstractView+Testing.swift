import Foundation
@testable import NativeMarkKit
#if canImport(UIKit)
import UIKit

typealias NativeImage = UIImage

extension AbstractView {
    func makeImage() -> NativeImage {
        UIGraphicsBeginImageContext(self.intrinsicSize())
        draw()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

#elseif canImport(AppKit)
import AppKit

typealias NativeImage = NSImage

extension AbstractView {
    func makeImage() -> NativeImage {
        let image = NSImage(size: self.intrinsicSize())
        image.lockFocusFlipped(true)
        draw()
        image.unlockFocus()
        return image
    }
}

#else
#error("Unsupported platform")
#endif
