import Foundation
#if canImport(AppKit)
import AppKit

extension CGRect {
    func fill() {
        NSBezierPath(rect: self).fill()
    }
    
    func clear() {
        NSGraphicsContext.current?.cgContext.clear(self)
    }
}

#elseif canImport(UIKit)
import UIKit

extension CGRect {
    func fill() {
        UIBezierPath(rect: self).fill()
    }
    
    func clear() {
        UIGraphicsGetCurrentContext()?.clear(self)
    }
}
#else
#error("Unsupported platform")
#endif
