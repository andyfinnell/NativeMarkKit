import Foundation

#if canImport(AppKit)
import AppKit

typealias NativeColor = NSColor
typealias NativeFont = NSFont
#elseif canImport(UIKit)
import UIKit

typealias NativeColor = UIColor
typealias NativeFont = UIFont

#elseif canImport(WatchKit)
import WatchKit

#else

// TODO: can we add support for watchOS and tvOS?
#error("Unsupported platform")

#endif
