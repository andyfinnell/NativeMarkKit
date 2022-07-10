import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class BlockQuoteTextContainerLayout: TextContainerLayout {
    private var layout: CompositeTextContainerLayout
    private let path: [ContainerKind]
    private let value: BlockQuoteValue
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }

    init(path: [ContainerKind], value: BlockQuoteValue) {
        self.path = path
        self.layout = CompositeTextContainerLayout(parentPath: path)
        self.value = value
    }

    func build(_ builder: TextContainerLayoutBuilder) {
        layout.superLayout = self
        layout.build(builder)
    }

    var paragraphSpacingAfter: CGFloat { layout.paragraphSpacingAfter }
    var paragraphSpacingBefore: CGFloat { layout.paragraphSpacingBefore }

    func measure(maxWidth: CGFloat) -> CGSize {
        let contentMaxWidth = maxWidth - value.leftPadding - value.rightPadding
        let contentSize = layout.measure(maxWidth: contentMaxWidth)
        return CGSize(width: contentSize.width + value.leftPadding + value.rightPadding,
                      height: contentSize.height + value.topPadding + value.bottomPadding)
    }
    
    func draw(at point: CGPoint) {
        let borderValue = BackgroundBorderValue(width: value.borderWidth,
                                               color: value.borderColor,
                                               sides: value.borderSides)
        borderValue.render(with: CGRect(origin: point + origin, size: size))
        layout.draw(at: point + origin)
    }
    
    func url(under point: CGPoint) -> URL? {
        guard frame.contains(point) else {
            return nil
        }
        let location = point - origin
        return layout.url(under: location)
    }
}

private extension BlockQuoteTextContainerLayout {
    func sizeDidChange() {
        let contentSize = CGSize(width: size.width - value.leftPadding - value.rightPadding,
                                 height: size.height - value.topPadding - value.bottomPadding)
        layout.origin = CGPoint(x: value.leftPadding, y: value.topPadding)
        layout.size = contentSize
    }
}
