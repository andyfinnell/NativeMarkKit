import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

protocol TextContainerLayout: AnyObject {
    var superLayout: TextContainerLayout? { get set }
    var origin: CGPoint { get set }
    var size: CGSize { get set }
    
    var paragraphSpacingAfter: CGFloat { get }
    var paragraphSpacingBefore: CGFloat { get }
    
    func measure(maxWidth: CGFloat) -> CGSize
    
    func draw(at point: CGPoint)
    
    func url(under point: CGPoint) -> URL?
}

extension TextContainerLayout {
    var frame: CGRect { CGRect(origin: origin, size: size) }
}
