import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class ListValue: NSObject {
    let leftPadding: CGFloat
    let rightPadding: CGFloat
    let topPadding: CGFloat
    let bottomPadding: CGFloat
    let markerToContentIndent: CGFloat
    let paragraphSpacingBefore: CGFloat
    let paragraphSpacingAfter: CGFloat
    
    init(leftPadding: CGFloat = 0,
         rightPadding: CGFloat = 0,
         topPadding: CGFloat = 0,
         bottomPadding: CGFloat = 0,
         markerToContentIndent: CGFloat = 0,
         paragraphSpacingBefore: CGFloat = 0,
         paragraphSpacingAfter: CGFloat = 0) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.markerToContentIndent = markerToContentIndent
        self.paragraphSpacingBefore = paragraphSpacingBefore
        self.paragraphSpacingAfter = paragraphSpacingAfter
        super.init()
    }
}
