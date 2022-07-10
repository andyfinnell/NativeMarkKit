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
    private let storage: NativeMarkStorage
    private let layoutManager = NativeMarkLayoutManager()
    private var layout = CompositeTextContainerLayout(parentPath: [])
    private var hasSetIntrinsicWidth = false
    private var currentlyTrackingUrl: URL?
    var bounds: CGRect = .zero {
        didSet {
            boundsDidChange()
        }
    }
    var nativeMark: String {
        didSet {
            nativeMarkDidChange()
        }
    }
    weak var delegate: AbstractViewDelegate?
    
    var onOpenLink: ((URL) -> Void)? = URLOpener.open
    
    init(nativeMark: String, styleSheet: StyleSheet) {
        self.nativeMark = nativeMark
        let nativeMarkString = NativeMarkString(nativeMark: nativeMark, styleSheet: styleSheet)
        self.storage = NativeMarkStorage(nativeMarkString: nativeMarkString)
        super.init()
        
        storage.addLayoutManager(layoutManager)
        
        layoutManager.delegate = self
        
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
        layoutManager.drawBackground(in: bounds)
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
        storage.nativeMarkString.isMultiline
    }
}

extension AbstractView: NativeMarkLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NativeMarkLayoutManager, invalidateFrame frame: CGRect, inContainer container: NativeMarkTextContainer) {
        delegate?.abstractViewDidInvalidateRect(frame)
    }
}

private extension AbstractView {
    func boundsDidChange() {
        layout.size = bounds.size
    }
                
    func nativeMarkDidChange() {
        let nativeMarkString = NativeMarkString(nativeMark: nativeMark, styleSheet: storage.nativeMarkString.styleSheet)
        storage.nativeMarkString = nativeMarkString
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
}
