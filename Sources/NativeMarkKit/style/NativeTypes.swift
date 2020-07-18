import Foundation

#if canImport(AppKit)
import AppKit

public typealias NativeColor = NSColor
public typealias NativeFont = NSFont
public typealias NativeFontWeight = NSFont.Weight

#elseif canImport(UIKit)
import UIKit

public typealias NativeColor = UIColor
public typealias NativeFont = UIFont
public typealias NativeFontWeight = UIFont.Weight

#else

// TODO: can we add support for watchOS?
#error("Unsupported platform")

#endif