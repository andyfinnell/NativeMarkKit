import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension CGFloat {
    static let largestMeasurableNumber: CGFloat = 1_000_000.0
}
