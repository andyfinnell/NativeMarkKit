import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct Points: Equatable {
    let value: CGFloat
    
    public init(value: CGFloat) {
        self.value = value
    }
    
    public static prefix func -(rhs: Points) -> Points {
        Points(value: -rhs.value)
    }
}

public extension Int {
    var pt: Length {
        .points(Points(value: CGFloat(self)))
    }
}

public extension Float {
    var pt: Length {
        .points(Points(value: CGFloat(self)))
    }
}

public extension Double {
    var pt: Length {
        .points(Points(value: CGFloat(self)))
    }
}
