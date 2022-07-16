import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class ListItemTextContainerLayout: TextContainerLayout {
    private var markerLayout: ListItemMarkerContainerLayout?
    private var contentLayout: ListItemContentTextContainerLayout?
    private let path: [ContainerKind]
    private let value: ListValue
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }

    init(path: [ContainerKind], value: ListValue) {
        self.path = path
        self.value = value
    }
    
    func build(_ builder: TextContainerLayoutBuilder) {
        // Start with the marker
        guard let containerBreak = builder.nextContainerBreak(),
              containerBreak.path.starts(with: path),
              containerBreak.path.last == .listItemMarker else {
            return
        }
        
        // We're confident we can handle it now
        builder.removeNextContainerBreak()

        markerLayout = ListItemMarkerContainerLayout(path: containerBreak.path,
                                                   textContainer: builder.makeTextContainer())
        markerLayout?.superLayout = self
        // Can't have any children, so don't try

        // Build out the content
        guard let containerBreak = builder.nextContainerBreak(),
              containerBreak.path.starts(with: path),
              containerBreak.path.last == .listItemContent else {
            return
        }
            
        // We're confident we can handle it now
        builder.removeNextContainerBreak()
            
        contentLayout = ListItemContentTextContainerLayout(path: containerBreak.path)
        contentLayout?.superLayout = self
        contentLayout?.build(builder)
    }
    
    var paragraphSpacingAfter: CGFloat { contentLayout?.paragraphSpacingAfter ?? 0.0 }
    var paragraphSpacingBefore: CGFloat { contentLayout?.paragraphSpacingBefore ?? 0.0 }

    func measure(maxWidth: CGFloat) -> CGSize {
        guard let markerLayout = markerLayout,
              let contentLayout = contentLayout else {
            return .zero
        }

        // The marker doesn't wrap
        let markerSize = markerLayout.measure(maxWidth: .largestMeasurableNumber)
        let offset = max(value.markerToContentIndent, markerSize.width)
        
        let contentMaxWidth = maxWidth - offset
        let contentSize = contentLayout.measure(maxWidth: contentMaxWidth)
        
        return CGSize(width: contentSize.width + offset,
                      height: max(markerSize.height, contentSize.height))
    }
    
    func draw(at point: CGPoint) {
        let offset = point + origin
        markerLayout?.draw(at: offset)
        contentLayout?.draw(at: offset)
    }
    
    func url(under point: CGPoint) -> URL? {
        guard let markerLayout = markerLayout,
              let contentLayout = contentLayout,
              frame.contains(point) else {
            return nil
        }
        let location = point - origin
        if let url = markerLayout.url(under: location) {
            return url
        }
        if let url = contentLayout.url(under: location) {
            return url
        }
        return nil
    }
}

private extension ListItemTextContainerLayout {
    func sizeDidChange() {
        guard let markerLayout = markerLayout,
              let contentLayout = contentLayout else {
            return
        }

        // The marker doesn't wrap
        let markerSize = markerLayout.measure(maxWidth: .largestMeasurableNumber)
        let offset = max(value.markerToContentIndent, markerSize.width)
        
        markerLayout.origin = .zero
        markerLayout.size = CGSize(width: offset, height: markerSize.height)
        
        let contentMaxWidth = max(size.width - offset, 0.0)
        let contentSize = contentLayout.measure(maxWidth: contentMaxWidth)
        var contentY: CGFloat = 0.0
        if markerSize.height > contentSize.height {
            contentY = ceil((markerSize.height - contentSize.height) / 2.0)
        }
        contentLayout.origin = CGPoint(x: offset, y: contentY)
        contentLayout.size = CGSize(width: contentMaxWidth, height: contentSize.height)
    }
}
