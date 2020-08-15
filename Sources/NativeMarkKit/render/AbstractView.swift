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
    private let container = NativeMarkTextContainer()
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
        
        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        
        layoutManager.delegate = self
    }
    
    func intrinsicSize() -> CGSize {
        let width = hasSetIntrinsicWidth ? bounds.width : .greatestFiniteMagnitude
        
        let computedSize = measure(maxWidth: width)
        
        hasSetIntrinsicWidth = true
        
        return computedSize
    }
    
    func draw() {
        layoutManager.drawBackground(in: bounds)
        let glyphRange = layoutManager.glyphRange(for: container)
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: .zero)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: .zero)
    }
    
    func beginTracking(at location: CGPoint) -> Bool {
        currentlyTrackingUrl = url(under: location)
        
        return currentlyTrackingUrl != nil
    }
    
    func continueTracking(at location: CGPoint) -> Bool {
        currentlyTrackingUrl != nil
    }
    
    func finishTracking(at location: CGPoint) {
        if let currentUrl = url(under: location), currentUrl == currentlyTrackingUrl {
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
            let frame = self.layoutManager.accessibilityFrame(for: attributeRange, in: container)
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
    func measure(maxWidth: CGFloat) -> CGSize {
        setContainerSize(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        let size = usedSize()
        
        setContainerSize(bounds.size)

        return size
    }
    
    func setContainerSize(_ size: CGSize) {
        container.size = size
        layoutManager.textContainerChangedGeometry(container)
    }
        
    func boundsDidChange() {
        setContainerSize(bounds.size)
    }
    
    func usedSize() -> CGSize {
        _ = layoutManager.glyphRange(for: container)
        return layoutManager.usedRect(for: container).integral.size
    }
    
    func url(under point: CGPoint) -> URL? {
        let characterIndex = layoutManager.characterIndex(for: point,
                                                          in: container,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)
        guard characterIndex >= 0 && characterIndex < storage.length,
            let url = storage.attribute(.nativeMarkLink, at: characterIndex, effectiveRange: nil) as? NSURL else {
            return nil
        }
        
        return url as URL
    }
        
    func nativeMarkDidChange() {
        let nativeMarkString = NativeMarkString(nativeMark: nativeMark, styleSheet: storage.nativeMarkString.styleSheet)
        storage.nativeMarkString = nativeMarkString
        hasSetIntrinsicWidth = false
    }
}
