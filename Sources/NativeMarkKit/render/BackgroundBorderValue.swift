import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class BackgroundBorderValue: NSObject {
    let width: CGFloat
    let color: NativeColor
    let sides: BorderSides
    
    init(width: CGFloat, color: NativeColor, sides: BorderSides) {
        self.width = width
        self.color = color
        self.sides = sides
    }
    
    func render(with backgroundFrame: CGRect) {
        color.set()
        
        if sides.contains(.left) {
            leftFrame(for: backgroundFrame).fill()
        }
        if sides.contains(.top) {
            topFrame(for: backgroundFrame).fill()
        }
        if sides.contains(.right) {
            rightFrame(for: backgroundFrame).fill()
        }
        if sides.contains(.bottom) {
            bottomFrame(for: backgroundFrame).fill()
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? BackgroundBorderValue else {
            return false
        }
        return width == rhs.width && color == rhs.color && sides == rhs.sides
    }
}

private extension BackgroundBorderValue {
    func leftFrame(for backgroundFrame: CGRect) -> CGRect {
        CGRect(x: backgroundFrame.minX,
               y: backgroundFrame.minY,
               width: width,
               height: backgroundFrame.height)
    }
    
    func rightFrame(for backgroundFrame: CGRect) -> CGRect {
        CGRect(x: backgroundFrame.maxX - width,
               y: backgroundFrame.minY,
               width: width,
               height: backgroundFrame.height)
    }

    func topFrame(for backgroundFrame: CGRect) -> CGRect {
        CGRect(x: backgroundFrame.minX,
               y: backgroundFrame.minY,
               width: backgroundFrame.width,
               height: width)
    }

    func bottomFrame(for backgroundFrame: CGRect) -> CGRect {
        CGRect(x: backgroundFrame.minX,
               y: backgroundFrame.maxY - width,
               width: backgroundFrame.width,
               height: width)
    }
}
