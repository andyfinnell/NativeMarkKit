import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol NativeMarkLayoutManagerDelegate: AnyObject {
    func layoutManager(_ layoutManager: NativeMarkLayoutManager, invalidateFrame frame: CGRect, inContainer container: NativeMarkTextContainer)
}

public final class NativeMarkLayoutManager: NSObject {
    let layoutManager = LayoutManager()
    public private(set) var textContainers = [NativeMarkTextContainer]()
    weak var storage: NativeMarkStorage?

    public weak var delegate: NativeMarkLayoutManagerDelegate?
    
    public override init() {
        super.init()
        layoutManager.delegate = self
    }
    
    public func addTextContainer(_ container: NativeMarkTextContainer) {
        guard !textContainers.contains(where: { $0 === container }) else {
            return
        }
        
        container.layoutManager = self
        textContainers.append(container)
        layoutManager.addTextContainer(container.container)
    }
    
    public func insertTextContainer(_ container: NativeMarkTextContainer, at index: Int) {
        guard !textContainers.contains(where: { $0 === container }) else {
            return
        }

        container.layoutManager = self
        textContainers.insert(container, at: index)
        layoutManager.insertTextContainer(container.container, at: index)
    }

    public func removeTextContainer(at index: Int) {
        guard let container = textContainers.at(index) else {
            return
        }

        container.layoutManager = nil
        textContainers.remove(at: index)
        layoutManager.removeTextContainer(at: index)
    }
    
    public func drawBackground(in bounds: CGRect) {
        var attributes = [NSAttributedString.Key: Any]()
        storage?.nativeMarkString.styleSheet.styles(for: .document).updateAttributes(&attributes)
        if let backgroundColor = attributes[.backgroundColor] as? NativeColor {
            backgroundColor.set()
            bounds.fill()
        } else {
            bounds.clear()
        }
    }

    public func drawBackground(forGlyphRange glyphRange: NSRange, at location: CGPoint) {
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: location)
    }
    
    public func drawGlyphs(forGlyphRange glyphRange: NSRange, at location: CGPoint) {
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: location)
    }

    public func glyphRange(for container: NativeMarkTextContainer) -> NSRange {
        layoutManager.glyphRange(for: container.container)
    }
    
    public func textContainerChangedGeometry(_ textContainer: NativeMarkTextContainer) {
        layoutManager.textContainerChangedGeometry(textContainer.container)
    }
    
    public func usedRect(for container: NativeMarkTextContainer) -> CGRect {
        layoutManager.usedRect(for: container.container)
    }
    
    public func accessibilityFrame(for characterRange: NSRange, in container: NativeMarkTextContainer) -> CGRect {
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        var rangeBounds = layoutManager.boundingRect(forGlyphRange: glyphRange, in: container.container)
        layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange,
                                              withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                                              in: container.container) { rect, stop in
            rangeBounds = rect
            stop.pointee = true
        }
        return rangeBounds
    }
    
    public func characterIndex(for location: CGPoint, in container: NativeMarkTextContainer, fractionOfDistanceBetweenInsertionPoints partialFraction: UnsafeMutablePointer<CGFloat>?) -> Int {
        layoutManager.characterIndex(for: location, in: container.container, fractionOfDistanceBetweenInsertionPoints: partialFraction)
    }
    
    public func glyphIndexForCharacter(at characterIndex: Int) -> Int {
        layoutManager.glyphIndexForCharacter(at: characterIndex)
    }
}

extension NativeMarkLayoutManager {
    func invalidateImage(in characterRange: NSRange) {
        layoutManager.invalidateLayout(forCharacterRange: characterRange, actualCharacterRange: nil)
        layoutManager.invalidateDisplay(forCharacterRange: characterRange)
        
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        
        if let container = layoutManager.textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil),
            let wrappedContainer = textContainers.first(where: { $0.container === container }) {
            let bounds = layoutManager.boundingRect(forGlyphRange: glyphRange, in: container)
            delegate?.layoutManager(self, invalidateFrame: bounds, inContainer: wrappedContainer)
        }
    }
        
    func horizontalLocation(for characterIndex: Int) -> CGFloat {
        let glyphIndex = layoutManager.glyphIndexForCharacter(at: characterIndex)
        let lineFragmentRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
        let locationInsideLineFragmentRect = layoutManager.location(forGlyphAt: glyphIndex)
        return lineFragmentRect.minX + locationInsideLineFragmentRect.x
    }
}

extension NativeMarkLayoutManager: NSLayoutManagerDelegate {
    public func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                
        var effectiveRange = characterRange
        if let blockBackground = storage?.attribute(.blockBackground, at: characterRange.location, effectiveRange: &effectiveRange) as? BackgroundValue {
            let isAtStart = characterRange.location == effectiveRange.location
            let isAtEnd = characterRange.upperBound == effectiveRange.upperBound
            let defaultFont = storage?.attribute(.font, at: characterRange.location, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()

            let topMargin = isAtStart ? blockBackground.topMargin.asRawPoints(for: defaultFont.pointSize) : 0
            let bottomMargin = isAtEnd ? blockBackground.bottomMargin.asRawPoints(for: defaultFont.pointSize) : 0
            
            let originalLineFragmentRect = lineFragmentRect.pointee
            let updatedLineFragmentRect = CGRect(x: originalLineFragmentRect.minX,
                                                 y: originalLineFragmentRect.minY,
                                                 width: originalLineFragmentRect.width,
                                                 height: originalLineFragmentRect.height + topMargin + bottomMargin)
            lineFragmentRect.assign(repeating: updatedLineFragmentRect, count: 1)

            let originalUsedRect = lineFragmentUsedRect.pointee
            let updatedUsedRect = CGRect(x: originalUsedRect.minX,
                                         y: updatedLineFragmentRect.minY + topMargin,
                                         width: originalUsedRect.width,
                                         height: originalUsedRect.height)
            lineFragmentUsedRect.assign(repeating: updatedUsedRect, count: 1)
            
            let originalBaseline = baselineOffset.pointee
            baselineOffset.assign(repeating: originalBaseline + topMargin, count: 1)
            
            if isAtStart || isAtEnd {
                return true
            } // else fall through
        }
        
        #if DEBUG
        if let storage = storage, let stringRange = Range(characterRange, in: storage.string) {
            let string = storage.string[stringRange]
            print("laying out [\(characterRange)](\(string)) at \(lineFragmentRect.pointee)")
        }
        #endif
        
        return false
    }
    
    public func layoutManager(_ layoutManager: NSLayoutManager, shouldUse action: NSLayoutManager.ControlCharacterAction, forControlCharacterAt charIndex: Int) -> NSLayoutManager.ControlCharacterAction {
        let ch = storage?.character(at: charIndex)
        if ch == 13 /* \r */ {
            return .lineBreak
        } else {
            return action
        }
    }
}
