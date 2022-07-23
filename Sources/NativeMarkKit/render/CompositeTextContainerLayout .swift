import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class CompositeTextContainerLayout: TextContainerLayout {
    private var layouts = [TextContainerLayout]()
    private let parentPath: [ContainerKind]
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }

    init(parentPath: [ContainerKind]) {
        self.parentPath = parentPath
    }
    
    func build(_ builder: TextContainerLayoutBuilder) {
        while let containerBreak = builder.nextContainerBreak(),
              containerBreak.path.starts(with: parentPath) {
            
            // We're confident we can handle it now
            builder.removeNextContainerBreak()
            
            switch containerBreak.path.last {
            case let .list(listValue, style: style):
                let layout = ListTextContainerLayout(path: containerBreak.path,
                                                     value: listValue,
                                                     style: style)
                layout.superLayout = self
                layouts.append(layout)
                layout.build(builder)
                
            case .leaf:
                let layout = LeafTextContainerLayout(path: containerBreak.path,
                                                     textContainer: builder.makeTextContainer(),
                                                     style: .none)
                layout.superLayout = self
                layouts.append(layout)
                // Can't have any children, so don't try
                
            case let .blockQuote(style):
                let layout = BlockQuoteTextContainerLayout(path: containerBreak.path, style: style)
                layout.superLayout = self
                layouts.append(layout)
                layout.build(builder)
                
            case let .codeBlock(style):
                let layout = LeafTextContainerLayout(path: containerBreak.path,
                                                     textContainer: builder.makeTextContainer(),
                                                     style: style)
                layout.superLayout = self
                layouts.append(layout)
                // Can't have any children, so don't try

            case .listItem,
                    .listItemContent,
                    .listItemMarker,
                    .none:
                break // should fail somehow as these should be unreachable
            }
        }
    }
    
    var paragraphSpacingAfter: CGFloat { layouts.last?.paragraphSpacingAfter ?? 0.0 }
    var paragraphSpacingBefore: CGFloat { layouts.first?.paragraphSpacingBefore ?? 0.0 }

    func measure(maxWidth: CGFloat) -> CGSize {        
        var relativeOrigin = CGPoint.zero
        var previousBottomSpacing: CGFloat = 0.0
        var hadPrevious = false
        var relativeWidth: CGFloat = 0.0
        
        for layout in layouts {
            let layoutSize = layout.measure(maxWidth: maxWidth)
            relativeWidth = max(layoutSize.width, relativeWidth)
            
            if hadPrevious {
                relativeOrigin.y += previousBottomSpacing + layout.paragraphSpacingBefore
            }
            
            relativeOrigin.y += layoutSize.height
            
            previousBottomSpacing = layout.paragraphSpacingAfter
            hadPrevious = true
        }

        return CGSize(width: relativeWidth, height: relativeOrigin.y)
    }
    
    func draw(at point: CGPoint) {
        let offset = point + origin
        for layout in layouts {
            layout.draw(at: offset)
        }
    }
    
    func url(under point: CGPoint) -> URL? {
        guard frame.contains(point) else {
            return nil
        }
        
        let location = point - origin
        for layout in layouts {
            if let url = layout.url(under: location) {
                return url
            }
        }
        
        return nil
    }
}

private extension CompositeTextContainerLayout {
    func sizeDidChange() {
        var relativeOrigin = CGPoint.zero
        var previousBottomSpacing: CGFloat = 0.0
        var hadPrevious = false
        
        for layout in layouts {
            let layoutSize = layout.measure(maxWidth: size.width)
            layout.size = CGSize(width: size.width, height: layoutSize.height)
            
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
