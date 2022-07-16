import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

func+(lhs: CGRect, rhs: CGPoint) -> CGRect {
    CGRect(origin: lhs.origin + rhs, size: lhs.size)
}

