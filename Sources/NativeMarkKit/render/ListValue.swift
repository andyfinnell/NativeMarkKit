import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class ListValue: NSObject {
    let markerToContentIndent: CGFloat
    
    init(markerToContentIndent: CGFloat = 0) {
        self.markerToContentIndent = markerToContentIndent
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ListValue else {
            return false
        }
        return markerToContentIndent == other.markerToContentIndent
    }
}
