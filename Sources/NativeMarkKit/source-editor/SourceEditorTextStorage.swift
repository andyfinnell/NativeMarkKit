import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class SourceEditorTextStorage: NSTextStorage {
    private let impl: NSMutableAttributedString
    private var lineStarts: [String.Index]
    private var document: Document
    private let highlighter = SourceEditorHighlighter() // could dependency inject instead

    var styleSheet: StyleSheet {
        didSet {
            styleSheetDidChange()
        }
    }

    init(editableNativeMark: String, styleSheet: StyleSheet) {
        impl = NSMutableAttributedString(string: editableNativeMark)
        self.styleSheet = styleSheet
        document = SourceEditorTextStorage.compile(editableNativeMark)
        lineStarts = SourceEditorTextStorage.computeLineStarts(for: editableNativeMark)
        
        super.init()
        
        highlighter.highlight(self, using: document, with: styleSheet)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if canImport(AppKit)
    @available(*, unavailable)
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    #endif
    
    override func processEditing() {

        if editedMask.contains(.editedCharacters) {
            document = SourceEditorTextStorage.compile(impl.string)
            lineStarts = SourceEditorTextStorage.computeLineStarts(for: impl.string)
                   
            highlighter.highlight(self, using: document, with: styleSheet)
        }
        
        
        super.processEditing()
    }
}

// MARK: - NSTextStorage class cluster

extension SourceEditorTextStorage {
    override var string: String {
        impl.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        impl.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        impl.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        impl.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
}

extension SourceEditorTextStorage: HighlightedSource {
    func textRange(_ range: TextRange?) -> NSRange? {
        guard let startIndex = textIndex(range?.start),
              let endIndex = textIndex(range?.end) else {
                  return nil
              }
        let nsRange = NSRange(startIndex...endIndex, in: impl.string)
        return nsRange
    }
    
    func setHighlightedAttributes(_ attributes: [NSAttributedString.Key: Any]?, range: NSRange) {
        impl.setAttributes(attributes, range: range)
    }
    
    func addHighlightedAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange) {
        impl.addAttributes(attributes, range: range)
    }

}

private extension SourceEditorTextStorage {
    func textIndex(_ position: TextPosition?) -> String.Index? {
        guard let lineNumber = position?.line,
              let lineStartIndex = lineStarts.at(lineNumber),
              let columnNumber = position?.column,
              let columnIndex = impl.string.index(lineStartIndex, offsetBy: columnNumber, limitedBy: impl.string.endIndex),
              columnIndex != impl.string.endIndex else {
                  return nil
              }
        
        return columnIndex
    }

    func styleSheetDidChange() {
        highlighter.highlight(self, using: document, with: styleSheet)
    }
    
    static func computeLineStarts(for editableNativeMark: String) -> [String.Index] {
         [editableNativeMark.startIndex] + editableNativeMark.indices(of: "\n").map { editableNativeMark.index(after: $0) }
    }
    
    static func compile(_ editableNativeMark: String) -> Document {
        (try? NativeMark.compile(editableNativeMark)) ?? Document(elements: [])
    }
}
