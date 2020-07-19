import Foundation

#if canImport(AppKit)
import AppKit

extension CGContext {
    // This is so gross. I'm sorry.
    private static var stack = [NSGraphicsContext]()
    
    func push() {
        let context = NSGraphicsContext(cgContext: self, flipped: true)
        if let current = NSGraphicsContext.current {
            Self.stack.append(current)
        }
        NSGraphicsContext.current = context
    }
    
    func pop() {
        guard let previous = Self.stack.popLast() else {
            return
        }
        NSGraphicsContext.current = previous
    }
}

#elseif canImport(UIKit)
import UIKit

extension CGContext {
    func push() {
        UIGraphicsPushContext(self)
    }
    
    func pop() {
        UIGraphicsPopContext()
    }
}

#else
#error("Unsupported platform")
#endif
