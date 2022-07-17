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
            backgroundFrame.leftFrame(for: width).fill()
        }
        if sides.contains(.top) {
            backgroundFrame.topFrame(for: width).fill()
        }
        if sides.contains(.right) {
            backgroundFrame.rightFrame(for: width).fill()
        }
        if sides.contains(.bottom) {
            backgroundFrame.bottomFrame(for: width).fill()
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? BackgroundBorderValue else {
            return false
        }
        return width == rhs.width && color == rhs.color && sides == rhs.sides
    }
}
