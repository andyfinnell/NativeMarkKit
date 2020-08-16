import Foundation
@testable import NativeMarkKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("Unsupported platform")
#endif

extension AbstractView {
    func makeImage() -> NativeImage {
        NativeImage.testImage(size: bounds.size, draw: self.draw)
    }
}
