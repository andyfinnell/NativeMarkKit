import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NSTextStorage {
    
    func character(at characterIndex: Int) -> unichar {
        mutableString.character(at: characterIndex)
    }
    
    func links() -> [(url: URL, range: Range<String.Index>, nsRange: NSRange)] {
        var links = [(url: URL, range: Range<String.Index>, nsRange: NSRange)]()
        enumerateAttribute(.nativeMarkLink, in: NSRange(location: 0, length: length), options: []) { attributeValue, attributeRange, _ in
            guard let url = attributeValue as? NSURL,
                  let labelRange = Range(attributeRange, in: string) else {
                return
            }
            links.append((url: url as URL, range: labelRange, nsRange: attributeRange))
        }
        return links
    }
    
    func link(at characterIndex: Int) -> URL? {
        safeAttribute(.nativeMarkLink, at: characterIndex, effectiveRange: nil) as? URL
    }
    
    func safeAttribute(_ attributeKey: NSAttributedString.Key, at characterIndex: Int, effectiveRange: NSRangePointer?) -> Any? {
        guard characterIndex < length else {
            return nil
        }
        return attribute(attributeKey, at: characterIndex, effectiveRange: effectiveRange)
    }
    
    func containerBreaks() -> [ContainerBreakValue] {
        var breaks = [ContainerBreakValue]()
        enumerateAttribute(.containerBreak, in: NSRange(location: 0, length: length)) { attributeValue, _, _ in
            guard let breakValue = attributeValue as? ContainerBreakValue else {
                return
            }
            breaks.append(breakValue)
        }
        return breaks
    }
    
    func accessibleText() -> String {
        string
    }
    
    var isMultiline: Bool {
        string.contains(where: { $0 == "\r" || $0 == "\n" })
    }

    func setDelegateForImageAttachments() {
        enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { value, _, _ in
            guard let imageAttachment = value as? ImageTextAttachment else { return }
            imageAttachment.layoutDelegate = self
        }
    }
}

extension NSTextStorage: ImageTextAttachmentLayoutDelegate {
    func imageTextAttachmentDidLoadImage(atCharacterIndex characterIndex: Int) {
        let characterRange = NSRange(location: characterIndex, length: 1)
        
        for layoutManager in layoutManagers {
            if let layout = layoutManager as? LayoutManager {
                layout.invalidateImage(in: characterRange)
            }
        }
    }
}
