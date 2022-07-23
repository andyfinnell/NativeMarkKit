import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class ListTextContainerLayout: TextContainerLayout {
    private let path: [ContainerKind]
    private var itemLayouts = [ListItemTextContainerLayout]()
    private let value: ListValue
    private let style: TextContainerStyle
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }
    
    init(path: [ContainerKind], value: ListValue, style: TextContainerStyle) {
        self.path = path
        self.value = value
        self.style = style
        // TODO: apply style
    }
    
    func build(_ builder: TextContainerLayoutBuilder) {
        while let containerBreak = builder.nextContainerBreak(),
              containerBreak.path.starts(with: path) {
            
            // We're confident we can handle it now
            builder.removeNextContainerBreak()
            
            switch containerBreak.path.last {
            case .listItem:
                let layout = ListItemTextContainerLayout(path: containerBreak.path, value: value)
                layout.superLayout = self
                itemLayouts.append(layout)
                layout.build(builder)
                                
            case .blockQuote,
                    .list,
                    .listItemMarker,
                    .listItemContent,
                    .leaf,
                    .codeBlock,
                    .none:
                break // should fail somehow as these should be unreachable
            }
        }
    }
    
    var paragraphSpacingAfter: CGFloat {
        itemLayouts.last?.paragraphSpacingAfter ?? 0.0
    }
    var paragraphSpacingBefore: CGFloat {
        itemLayouts.first?.paragraphSpacingBefore ?? 0.0
    }

    func measure(maxWidth: CGFloat) -> CGSize {
        style.measure(maxWidth: maxWidth) { contentMaxWidth in
            var relativeOrigin = CGPoint.zero
            var previousBottomSpacing: CGFloat = 0.0
            var hadPrevious = false
            var relativeWidth: CGFloat = 0.0
            
            for layout in itemLayouts {
                let layoutSize = layout.measure(maxWidth: contentMaxWidth)
                relativeWidth = max(layoutSize.width, relativeWidth)
                
                if hadPrevious {
                    relativeOrigin.y += previousBottomSpacing + layout.paragraphSpacingBefore
                }
                
                relativeOrigin.y += layoutSize.height
                
                previousBottomSpacing = layout.paragraphSpacingAfter
                hadPrevious = true
            }

            return CGSize(width: relativeWidth,
                          height: relativeOrigin.y)

        }
    }
    
    func draw(at point: CGPoint) {
        let offset = point + origin
        style.draw(in: CGRect(origin: offset, size: size))
        for layout in itemLayouts {
            layout.draw(at: offset)
        }
    }
    
    func url(under point: CGPoint) -> URL? {
        guard frame.contains(point) else {
            return nil
        }
        
        let location = point - origin
        for layout in itemLayouts {
            if let url = layout.url(under: location) {
                return url
            }
        }
        
        return nil
    }
}

private extension ListTextContainerLayout {
    func sizeDidChange() {
        let contentFrame = style.contentFrame(for: size)
        var relativeOrigin = contentFrame.origin
        var previousBottomSpacing: CGFloat = 0.0
        var hadPrevious = false

        for layout in itemLayouts {
            let layoutSize = layout.measure(maxWidth: contentFrame.width)
            layout.size = CGSize(width: contentFrame.width, height: layoutSize.height)
            
            if hadPrevious {
                relativeOrigin.y += previousBottomSpacing + layout.paragraphSpacingBefore
            }

            layout.origin = relativeOrigin
            relativeOrigin.y += layoutSize.height
            
            previousBottomSpacing = layout.paragraphSpacingAfter
            hadPrevious = true
        }
    }

}
