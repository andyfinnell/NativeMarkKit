import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class BlockQuoteTextContainerLayout: TextContainerLayout {
    private var layout: CompositeTextContainerLayout
    private let path: [ContainerKind]
    private let style: TextContainerStyle
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }

    init(path: [ContainerKind], style: TextContainerStyle) {
        self.path = path
        self.layout = CompositeTextContainerLayout(parentPath: path)
        self.style = style
    }

    func build(_ builder: TextContainerLayoutBuilder) {
        layout.superLayout = self
        layout.build(builder)
    }

    var paragraphSpacingAfter: CGFloat { layout.paragraphSpacingAfter }
    var paragraphSpacingBefore: CGFloat { layout.paragraphSpacingBefore }

    func measure(maxWidth: CGFloat) -> CGSize {
        style.measure(maxWidth: maxWidth) { contentMaxWidth in
            layout.measure(maxWidth: contentMaxWidth)
        }
    }
    
    func draw(at point: CGPoint) {
        let offset = point + origin
        style.draw(in: CGRect(origin: offset, size: size))
        layout.draw(at: offset)
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
        let contentFrame = style.contentFrame(for: size)
        layout.origin = contentFrame.origin
        layout.size = contentFrame.size
    }
}
