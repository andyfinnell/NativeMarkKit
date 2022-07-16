import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

protocol AbstractViewDelegate: AnyObject {
    func abstractViewDidInvalidateRect(_ rect: CGRect)
}

final class AbstractView: NSObject {
    private let storage: NSTextStorage
    private let layoutManager = LayoutManager()
    private var layout = CompositeTextContainerLayout(parentPath: [])
    private var hasSetIntrinsicWidth = false
    private var currentlyTrackingUrl: URL?
    var bounds: CGRect = .zero {
        didSet {
            boundsDidChange()
        }
    }
    var document: Document {
        didSet {
            documentDidChange()
        }
    }
    var styleSheet: StyleSheet {
        didSet {
            styleSheetDidChange()
        }
    }
    weak var delegate: AbstractViewDelegate?
    
    var onOpenLink: ((URL) -> Void)? = URLOpener.open
    
    init(document: Document, styleSheet: StyleSheet) {
        self.document = document
        self.styleSheet = styleSheet
        
        self.storage = NSTextStorage()
        super.init()
        
        resetStorage()
        storage.addLayoutManager(layoutManager)
        
        layoutManager.invalidationDelegate = self
        
        buildLayout()
    }
    
    func intrinsicSize() -> CGSize {
        let width = hasSetIntrinsicWidth ? bounds.width : .largestMeasurableNumber
        
        let computedSize = layout.measure(maxWidth: width)
        
        hasSetIntrinsicWidth = true
        
        return CGSize(width: computedSize.width.rounded(.up),
                      height: computedSize.height.rounded(.up))
    }
    
    func draw() {
        layoutManager.drawBackground(in: bounds, using: styleSheet)
        layout.draw(at: .zero)
    }
    
    func beginTracking(at location: CGPoint) -> Bool {
        currentlyTrackingUrl = layout.url(under: location)
        
        return currentlyTrackingUrl != nil
    }
    
    func continueTracking(at location: CGPoint) -> Bool {
        currentlyTrackingUrl != nil
    }
    
    func finishTracking(at location: CGPoint) {
        if let currentUrl = layout.url(under: location), currentUrl == currentlyTrackingUrl {
            onOpenLink?(currentUrl)
        }
        
        currentlyTrackingUrl = nil
    }
    
    func cancelTracking() {
        currentlyTrackingUrl = nil
    }
    
    func accessibleText() -> String {
        storage.string
    }
    
    func accessibleUrls() -> [AccessibileURL] {
        storage.links().map { url, labelRange, attributeRange in
            let label = String(storage.string[labelRange])
            let frame = self.layoutManager.accessibilityFrame(for: attributeRange)
            return AccessibileURL(label: label, url: url, frame: frame)
        }
    }
    
    var isMultiline: Bool {
        storage.isMultiline
    }
}

extension AbstractView: LayoutManagerDelegate {
    func layoutManager(_ layoutManager: LayoutManager, invalidateFrame frame: CGRect, inContainer container: TextContainer) {
        delegate?.abstractViewDidInvalidateRect(frame)
    }
}

private extension AbstractView {
    func boundsDidChange() {
        layout.size = bounds.size
    }
    
    func styleSheetDidChange() {
        documentDidChange() // for now, treat it the same as the source changing
    }
    
    func documentDidChange() {
        resetStorage()
        buildLayout()
        hasSetIntrinsicWidth = false
    }
    
    func buildLayout() {
        let builder = TextContainerLayoutBuilder(storage: storage,
                                                 layoutManager: layoutManager)
        layout = CompositeTextContainerLayout(parentPath: [])
        layout.build(builder)
        builder.removeUnusedTextContainers()
        layout.size = bounds.size
    }
    
    func resetStorage() {
        let renderer = Renderer()
        let attributedString = NSAttributedString(attributedString: renderer.render(document, with: styleSheet))
        storage.setAttributedString(attributedString)
        storage.setDelegateForImageAttachments()
    }
}
