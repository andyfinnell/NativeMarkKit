import Foundation

#if canImport(AppKit)
import AppKit

public typealias NativeColor = NSColor
public typealias NativeFont = NSFont
public typealias NativeFontWeight = NSFont.Weight
public typealias NativeImage = NSImage

#elseif canImport(UIKit)
import UIKit

public typealias NativeColor = UIColor
public typealias NativeFont = UIFont
public typealias NativeFontWeight = UIFont.Weight
public typealias NativeImage = UIImage

#else

#error("Unsupported platform")

#endif
