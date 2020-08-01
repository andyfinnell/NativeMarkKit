import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public extension NativeColor {
    static let veryLightGray = NativeColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    static let veryDarkGray = NativeColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    static let backgroundGray = NativeColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
}
