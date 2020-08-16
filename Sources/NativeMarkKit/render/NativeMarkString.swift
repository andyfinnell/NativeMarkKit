import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NativeMarkString {
    private(set) var attributedString: NSAttributedString
    public let styleSheet: StyleSheet
    public var nativeMark: String {
        didSet {
            nativeMarkDidChange()
        }
    }
        
    public init(nativeMark: String, styleSheet: StyleSheet) {
        self.styleSheet = styleSheet
        self.nativeMark = nativeMark
        self.attributedString = (try? NSAttributedString(nativeMark: nativeMark, styleSheet: styleSheet))
            ?? NSAttributedString(string: nativeMark)
    }
    
    public func draw(at point: CGPoint) {
        let storage = NativeMarkStorage(nativeMarkString: self)
        let layoutManager = NativeMarkLayoutManager()
        let textContainer = NativeMarkTextContainer()
        textContainer.size = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                    height: .greatestFiniteMagnitude)
        storage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.textContainerChangedGeometry(textContainer)

        _ = layoutManager.glyphRange(for: textContainer)
        let usedRect = layoutManager.usedRect(for: textContainer)
        
        let rect = CGRect(origin: point, size: usedRect.size).integral
        layoutManager.drawBackground(in: rect)
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: rect.origin)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: rect.origin)
    }
    
    public func draw(in rect: CGRect) {
        let storage = NativeMarkStorage(nativeMarkString: self)
        let layoutManager = NativeMarkLayoutManager()
        let textContainer = NativeMarkTextContainer()
        textContainer.size = rect.integral.size
        storage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.textContainerChangedGeometry(textContainer)

        layoutManager.drawBackground(in: rect.integral)
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: rect.origin)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: rect.origin)
    }
    
    public func boundingRect(with containerSize: CGSize) -> CGRect {
        let storage = NativeMarkStorage(nativeMarkString: self)
        let layoutManager = NativeMarkLayoutManager()
        let textContainer = NativeMarkTextContainer()
        textContainer.size = containerSize
        storage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.textContainerChangedGeometry(textContainer)

        _ = layoutManager.glyphRange(for: textContainer)
        return layoutManager.usedRect(for: textContainer)
    }
}

extension NativeMarkString {
    func accessibleText() -> String {
        attributedString.string
    }
    
    var isMultiline: Bool {
        attributedString.string.contains(where: { $0 == "\r" || $0 == "\n" })
    }
}

private extension NativeMarkString {
    func nativeMarkDidChange() {
        do {
            attributedString = try NSAttributedString(nativeMark: nativeMark, styleSheet: styleSheet)
        } catch {
            // do nothing if it's not valid NativeMark
        }
    }
}
