import Foundation

#if canImport(AppKit)
import AppKit

public typealias NativeColor = NSColor
public typealias NativeFont = NSFont
public typealias NativeFontWeight = NSFont.Weight
public typealias NativeImage = NSImage
public typealias NativeBezierPath = NSBezierPath

extension NSBezierPath {
    convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
}

#elseif canImport(UIKit)
import UIKit

public typealias NativeColor = UIColor
public typealias NativeFont = UIFont
public typealias NativeFontWeight = UIFont.Weight
public typealias NativeImage = UIImage
public typealias NativeBezierPath = UIBezierPath

#else

#error("Unsupported platform")

#endif
