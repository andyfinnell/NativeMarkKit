import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

struct TextContainerStyle: Equatable {
    let margin: PointMargin?
    let border: Border?
    let padding: PointPadding?
    let backgroundColor: NativeColor?
}

extension TextContainerStyle {
    static let none = TextContainerStyle(margin: nil, border: nil, padding: nil, backgroundColor: nil)
    
    func measure(maxWidth: CGFloat, content: (CGFloat) -> CGSize) -> CGSize {
        let contentMaxWidth = maxWidth - leftOffset - rightOffset
        let contentSize = content(contentMaxWidth)
        return CGSize(width: contentSize.width + leftOffset + rightOffset,
                      height: contentSize.height + topOffset + bottomOffset)
    }

    func draw(in frame: CGRect) {
        var borderFrame = margin.map { frame.inset(by: $0) } ?? frame
        let paddingFrame = border.map { borderFrame.inset(by: $0) } ?? borderFrame
        if let border = border {
            if border.width == 1.0 {
                borderFrame = borderFrame.integral
            }

            border.draw(in: borderFrame, background: drawBackground(in:))
        } else {
            drawBackground(in: paddingFrame)
        }
    }
    
    func contentFrame(for size: CGSize) -> CGRect {
        CGRect(x: leftOffset,
               y: topOffset,
               width: size.width - leftOffset - rightOffset,
               height: size.height - topOffset - bottomOffset)
    }
    
    var leftOffset: CGFloat {
        let marginOffset = margin?.left ?? 0
        let borderOffset = border?.leftOffset ?? 0
        let paddingOffset = padding?.left ?? 0
        return marginOffset + borderOffset + paddingOffset
    }
    
    var rightOffset: CGFloat {
        let marginOffset = margin?.right ?? 0
        let borderOffset = border?.rightOffset ?? 0
        let paddingOffset = padding?.right ?? 0
        return marginOffset + borderOffset + paddingOffset
    }
    
    var topOffset: CGFloat {
        let marginOffset = margin?.top ?? 0
        let borderOffset = border?.topOffset ?? 0
        let paddingOffset = padding?.top ?? 0
        return marginOffset + borderOffset + paddingOffset
    }

    var bottomOffset: CGFloat {
        let marginOffset = margin?.bottom ?? 0
        let borderOffset = border?.bottomOffset ?? 0
        let paddingOffset = padding?.bottom ?? 0
        return marginOffset + borderOffset + paddingOffset
    }
}

private extension TextContainerStyle {
    func drawBackground(in frame: CGRect) {
        guard let color = backgroundColor else {
            return
        }
        color.setFill()
        NativeBezierPath(rect: frame).fill()
    }
}
