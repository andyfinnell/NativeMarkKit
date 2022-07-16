import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class ListItemContentTextContainerLayout: TextContainerLayout {
    private var layout: CompositeTextContainerLayout
    private let path: [ContainerKind]
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }

    init(path: [ContainerKind]) {
        self.path = path
        self.layout = CompositeTextContainerLayout(parentPath: path)
    }

    func build(_ builder: TextContainerLayoutBuilder) {
        layout.superLayout = self
        layout.build(builder)
    }
    
    var paragraphSpacingAfter: CGFloat { layout.paragraphSpacingAfter }
    var paragraphSpacingBefore: CGFloat { layout.paragraphSpacingBefore }
    
    func measure(maxWidth: CGFloat) -> CGSize {
        layout.measure(maxWidth: maxWidth)
    }
    
    func draw(at point: CGPoint) {
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

private extension ListItemContentTextContainerLayout {
    func sizeDidChange() {
        layout.origin = .zero
        layout.size = size
    }
}
