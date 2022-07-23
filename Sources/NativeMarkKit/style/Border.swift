import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public enum BorderShape: Equatable {
    case roundedRect(cornerRadius: CGFloat)
    case rectangle(sides: BorderSides)
}

public struct Border: Equatable {
    public let shape: BorderShape
    public let width: CGFloat
    public let color: NativeColor
    
    public init(shape: BorderShape, width: CGFloat, color: NativeColor) {
        self.shape = shape
        self.width = width
        self.color = color
    }
}

extension Border {
    var leftOffset: CGFloat {
        shape.offsetMultipler(for: .left) * width
    }

    var rightOffset: CGFloat {
        shape.offsetMultipler(for: .right) * width
    }

    var topOffset: CGFloat {
        shape.offsetMultipler(for: .top) * width
    }

    var bottomOffset: CGFloat {
        shape.offsetMultipler(for: .bottom) * width
    }
    
    func draw(in frame: CGRect, background: (CGRect) -> Void) {
        switch shape {
        case let .rectangle(sides: sides):
            drawRectangle(in: frame, sides: sides, background: background)
        case let .roundedRect(cornerRadius: radius):
            drawRoundedRect(in: frame, cornerRadius: radius, background: background)
        }
    }
}

private extension Border {
    func drawRectangle(in frame: CGRect, sides: BorderSides, background: (CGRect) -> Void) {
        // Draw background first
        background(frame.inset(by: self))
        
        // Be sure to draw the border _over_ the background
        color.set()
        if sides.contains(.left) {
            frame.leftFrame(for: width).fill()
        }
        if sides.contains(.top) {
            frame.topFrame(for: width).fill()
        }
        if sides.contains(.right) {
            frame.rightFrame(for: width).fill()
        }
        if sides.contains(.bottom) {
            frame.bottomFrame(for: width).fill()
        }
    }
    
    func drawRoundedRect(in frame: CGRect, cornerRadius: CGFloat, background: (CGRect) -> Void) {
        // CoreGraphics draws the stroke splitting the bounds we give it (half the width
        //  on one side of the path), which doesn't match the drawing model we want
        //  to represent. So inset the frame by half the width
        let pathFrame = frame.insetBy(dx: width / 2.0, dy: width / 2.0)
        let path = NativeBezierPath(roundedRect: pathFrame, cornerRadius: cornerRadius)

        // Draw background first
        saveGraphicsState()
        path.addClip()
        background(frame.inset(by: self))
        restoreGraphicsState()
        
        // Be sure to draw the border _over_ the background
        color.set()
        path.lineWidth = width
        path.stroke()
    }

}

private extension BorderShape {
    func offsetMultipler(for borderSide: BorderSides) -> CGFloat {
        switch self {
        case .roundedRect:
            return 1.0
        case let .rectangle(sides: sides):
            return sides.contains(borderSide) ? 1.0 : 0.0
        }
    }
}
