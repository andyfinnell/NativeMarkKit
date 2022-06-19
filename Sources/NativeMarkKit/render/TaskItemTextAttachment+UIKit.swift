import Foundation
#if canImport(UIKit)
import UIKit

final class TaskItemTextAttachment: NSTextAttachment {
    private let isChecked: Bool
    
    init(isChecked: Bool) {
        self.isChecked = isChecked
        super.init(data: nil, ofType: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
        NativeImage.make(size: imageBounds.size) {
            let bounds = CGRect(origin: .zero, size: imageBounds.size)
            let innerBounds = bounds.insetBy(dx: 0.5, dy: 0.5)
            let backgroundPath = UIBezierPath(roundedRect: innerBounds, cornerRadius: 4)
            
            backgroundPath.lineWidth = 1
            
            UIColor.adaptableCheckmarkDisabledBorderColor.set()
            backgroundPath.stroke()
                        
            if isChecked {
                let checkPath = UIBezierPath()
                checkPath.move(to: CGPoint(x: 3.5, y: 8.5))
                checkPath.addLine(to: CGPoint(x: 6.5, y: 11.5))
                checkPath.addLine(to: CGPoint(x: 11.5, y: 4.5))
                
                checkPath.lineWidth = 3
                checkPath.lineCapStyle = .round
                checkPath.lineJoinStyle = .round
                
                UIColor.adaptableCheckmarkDisabledColor.set()
                checkPath.stroke()
            }
        }
    }

    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let yOffset = CGFloat(4) // (lineFrag.height - 16.0) / 2.0
        return CGRect(x: 0, y: -yOffset, width: 16, height: 16)
    }

}

#endif

