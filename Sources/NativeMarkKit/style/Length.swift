import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public enum Length: Equatable {
    case em(Em)
    case points(Points)
    
    public static prefix func -(rhs: Length) -> Length {
        switch rhs {
        case let .em(em):
            return .em(-em)
        case let .points(points):
            return .points(-points)
        }
    }
}

extension Length {
    func asRawPoints(for fontSize: CGFloat) -> CGFloat {
        switch self {
        case let .em(em):
            return em.asPoints(for: fontSize).value
        case let .points(points):
            return points.value
        }
    }
}
