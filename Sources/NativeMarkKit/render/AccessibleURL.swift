import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

struct AccessibileURL {
    let label: String
    let url: URL
    let frame: CGRect
}
