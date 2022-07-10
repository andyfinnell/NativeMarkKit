import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NativeMarkStorage {
    public private(set) var layoutManagers = [NativeMarkLayoutManager]()
    private let storage: NSTextStorage
    public var nativeMarkString: NativeMarkString {
        didSet {
            stringDidChange()
        }
    }
    
    public init(nativeMarkString: NativeMarkString) {
        self.nativeMarkString = nativeMarkString
        self.storage = NSTextStorage(attributedString: nativeMarkString.attributedString)
        setDelegateForImageAttachments()
    }
    
    public func addLayoutManager(_ layoutManager: NativeMarkLayoutManager) {
        guard !layoutManagers.contains(where: { $0 === layoutManager }) else {
            return
        }
        layoutManager.storage = self
        layoutManagers.append(layoutManager)
        storage.addLayoutManager(layoutManager.layoutManager)
    }
    
    public func removeLayoutManager(_ layoutManager: NativeMarkLayoutManager) {
        guard layoutManagers.contains(where: { $0 === layoutManager }) else {
            return
        }
        layoutManager.storage = nil
        layoutManagers.removeAll(where: { $0 === layoutManager })
        storage.removeLayoutManager(layoutManager.layoutManager)
    }
    
    public func character(at characterIndex: Int) -> unichar {
        storage.mutableString.character(at: characterIndex)
    }
    
    public var string: String {
        storage.string
    }
    
    public var length: Int {
        storage.length
    }
    
    public func links() -> [(url: URL, range: Range<String.Index>, nsRange: NSRange)] {
        var links = [(url: URL, range: Range<String.Index>, nsRange: NSRange)]()
        storage.enumerateAttribute(.nativeMarkLink, in: NSRange(location: 0, length: storage.length), options: []) { attributeValue, attributeRange, _ in
            guard let url = attributeValue as? NSURL,
                let labelRange = Range(attributeRange, in: storage.string) else {
                    return
            }
            links.append((url: url as URL, range: labelRange, nsRange: attributeRange))
        }
        return links
    }
    
    public func link(at characterIndex: Int) -> URL? {
        storage.attribute(.nativeMarkLink, at: characterIndex, effectiveRange: nil) as? URL
    }
}

extension NativeMarkStorage {
    func attribute(_ attributeKey: NSAttributedString.Key, at characterIndex: Int, effectiveRange: NSRangePointer?) -> Any? {
        guard characterIndex < storage.length else {
            return nil
        }
        return storage.attribute(attributeKey, at: characterIndex, effectiveRange: effectiveRange)
    }
    
    func containerBreaks() -> [ContainerBreakValue] {
        var breaks = [ContainerBreakValue]()
        storage.enumerateAttribute(.containerBreak, in: NSRange(location: 0, length: storage.length)) { attributeValue, _, _ in
            guard let breakValue = attributeValue as? ContainerBreakValue else {
                return
            }
            breaks.append(breakValue)
        }
        return breaks
    }
}

private extension NativeMarkStorage {
    func stringDidChange() {
        storage.setAttributedString(nativeMarkString.attributedString)
        
        setDelegateForImageAttachments()
    }
    
    func setDelegateForImageAttachments() {
        storage.enumerateAttribute(.attachment, in: NSRange(location: 0, length: storage.length), options: []) { value, _, _ in
            guard let imageAttachment = value as? ImageTextAttachment else { return }
            imageAttachment.layoutDelegate = self
        }
    }
}

extension NativeMarkStorage: ImageTextAttachmentLayoutDelegate {
    func imageTextAttachmentDidLoadImage(atCharacterIndex characterIndex: Int) {
        let characterRange = NSRange(location: characterIndex, length: 1)
        
        for layoutManager in layoutManagers {
            layoutManager.invalidateImage(in: characterRange)
        }
    }
}
