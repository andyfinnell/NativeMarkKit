import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public extension NativeColor {
    static let veryLightGray = NativeColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.9)
}
