import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

func+(lhs: CGRect, rhs: CGPoint) -> CGRect {
    CGRect(origin: lhs.origin + rhs, size: lhs.size)
}

extension CGRect {
    func inset(by value: FourSidedValue<CGFloat>) -> CGRect {
        CGRect(x: minX + value.left,
               y: minY + value.top,
               width: width - value.left - value.right,
               height: height - value.top - value.bottom)
    }
    
    func inset(by value: Border) -> CGRect {
        CGRect(x: minX + value.leftOffset,
               y: minY + value.topOffset,
               width: width - value.leftOffset - value.rightOffset,
               height: height - value.topOffset - value.bottomOffset)
    }

    func leftFrame(for borderWidth: CGFloat) -> CGRect {
        CGRect(x: minX,
               y: minY,
               width: borderWidth,
               height: height)
    }
    
    func rightFrame(for borderWidth: CGFloat) -> CGRect {
        CGRect(x: maxX - borderWidth,
               y: minY,
               width: borderWidth,
               height: height)
    }

    func topFrame(for borderWidth: CGFloat) -> CGRect {
        CGRect(x: minX,
               y: minY,
               width: width,
               height: borderWidth)
    }

    func bottomFrame(for borderWidth: CGFloat) -> CGRect {
        CGRect(x: minX,
               y: maxY - borderWidth,
               width: width,
               height: borderWidth)
    }

}
