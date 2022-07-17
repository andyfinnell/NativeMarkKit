import Foundation
#if canImport(AppKit)
import AppKit

func saveGraphicsState() {
    NSGraphicsContext.saveGraphicsState()
}

func restoreGraphicsState() {
    NSGraphicsContext.restoreGraphicsState()
}

#elseif canImport(UIKit)
import UIKit

func saveGraphicsState() {
    UIGraphicsGetCurrentContext()?.saveGState()
}

func restoreGraphicsState() {
    UIGraphicsGetCurrentContext()?.restoreGState()
}

#endif

