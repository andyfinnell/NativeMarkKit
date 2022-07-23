import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public typealias Margin = FourSidedValue<Length>
typealias PointMargin = FourSidedValue<CGFloat>
