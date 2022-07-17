import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class CodeBlockBackgroundValue: NSObject {
    let fillColor: NativeColor
    let strokeColor: NativeColor
    let strokeWidth: CGFloat
    let cornerRadius: CGFloat
    let topMargin: Length
    let bottomMargin: Length
    let leftMargin: Length
    let rightMargin: Length
    
    init(fillColor: NativeColor, strokeColor: NativeColor, strokeWidth: CGFloat,
         cornerRadius: CGFloat, topMargin: Length, bottomMargin: Length,
         leftMargin: Length, rightMargin: Length) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.cornerRadius = cornerRadius
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        super.init()
    }
    
    func render(in rect: CGRect, defaultFont: NativeFont) {
        let topMarginInPts = topMargin.asRawPoints(for: defaultFont.pointSize)
        let bottomMarginInPts = bottomMargin.asRawPoints(for: defaultFont.pointSize)
        let leftMarginInPts = leftMargin.asRawPoints(for: defaultFont.pointSize)
        let rightMarginInPts = rightMargin.asRawPoints(for: defaultFont.pointSize)
        
        let frame = CGRect(x: round(rect.minX - leftMarginInPts) + strokeWidth / 2.0,
                           y: round(rect.minY - topMarginInPts) + strokeWidth / 2.0,
                           width: round(rect.width + leftMarginInPts + rightMarginInPts) - strokeWidth,
                           height: round(rect.height + topMarginInPts + bottomMarginInPts) - strokeWidth)
        
        let path = NativeBezierPath(roundedRect: frame, cornerRadius: cornerRadius)
        path.lineWidth = strokeWidth
        fillColor.setFill()
        strokeColor.setStroke()
        path.fill()
        path.stroke()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? CodeBlockBackgroundValue else {
            return false
        }
        
        return fillColor == rhs.fillColor && strokeColor == rhs.strokeColor
            && strokeWidth == rhs.strokeWidth && cornerRadius == rhs.cornerRadius
            && topMargin == rhs.topMargin && bottomMargin == rhs.bottomMargin
            && leftMargin == rhs.leftMargin && rightMargin == rhs.rightMargin
    }
}
