import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

struct Renderer {
    init() {}
    
    func render(_ document: Document, with stylesheet: StyleSheet) -> NSAttributedString {        
        let result = NSMutableAttributedString()
        let styleStack = StyleStack(stylesheet: stylesheet)
        styleStack.push(.document)
        defer {
            styleStack.pop()
        }
        render(document.elements, indent: 0, with: styleStack, into: result)
        
        if result.string.hasSuffix("\n") {
            result.deleteCharacters(in: NSRange(location: result.length - 1, length: 1))
        }
        
        fixInlineBackgroundSpacing(in: result)
        
        return result
    }
}

private extension Renderer {
    func fixInlineBackgroundSpacing(in result: NSMutableAttributedString) {
        result.enumerateAttribute(.inlineBackground, in: NSRange(location: 0, length: result.length), options: .reverse) { value, characterRange, _ in
            guard let background = value as? BackgroundValue else { return }
            
            insertSpacer(background.rightMargin, at: characterRange.upperBound, in: result)
            insertSpacer(background.leftMargin, at: characterRange.lowerBound, in: result)
        }
    }
    
    func render(_ elements: [Element], indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        for element in elements {
            render(element, indent: indent, with: styleStack, into: result)
        }
    }
    
    func render(_ element: Element, indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        switch element {
        case let .paragraph(paragraph):
            renderParagraph(paragraph.text, indent: indent, with: styleStack, into: result)
        case .thematicBreak:
            renderThematicBreak(with: styleStack, into: result)
        case let .heading(heading):
            renderHeading(level: heading.level, text: heading.text, indent: indent, with: styleStack, into: result)
        case let .blockQuote(blockQuote):
            renderBlockQuote(blockQuote.blocks, indent: indent, with: styleStack, into: result)
        case let .codeBlock(codeBlock):
            renderCodeBlock(info: codeBlock.infoString, text: codeBlock.content, indent: indent, with: styleStack, into: result)
        case let .list(list):
            renderList(list.info, items: list.items, indent: indent, with: styleStack, into: result)
        }
    }
    
    func renderParagraph(_ text: [InlineText], indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.paragraph)
        defer {
            styleStack.pop()
        }
        
        render(text, with: styleStack, into: result)
        renderNewline(with: styleStack, into: result)
    }
    
    func renderThematicBreak(with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.thematicBreak)
        defer {
            styleStack.pop()
        }
        
        let attributes = styleStack.attributes()
        let thickness = attributes[.thematicBreakThickness] as? CGFloat ?? 1.0
        let color = attributes[.thematicBreakColor] as? NativeColor ?? .adaptableSeparatorColor
        let attachment = ThematicBreakAttachment(thickness: thickness, color: color)
        
        renderTextAttachment(attachment, with: styleStack, into: result)
        renderNewline(with: styleStack, into: result)
    }
    
    func renderHeading(level: Int, text: [InlineText], indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.heading(level: level))
        defer {
            styleStack.pop()
        }

        render(text, with: styleStack, into: result)
        renderNewline(with: styleStack, into: result)
    }
        
    func renderBlockQuote(_ elements: [Element], indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.blockQuote, rawAttributes: [.leadingMarginIndent: indent + 1])
        defer {
            styleStack.pop()
        }
        
        result.append(NSAttributedString(string: "\t", attributes: styleStack.attributes()))

        render(elements, indent: indent + 1, with: styleStack, into: result)
    }

    func renderCodeBlock(info: String, text: String, indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        // TODO: delegate out so let a more sophisticated renderer do syntax highlighting
        styleStack.push(.codeBlock)
        defer {
            styleStack.pop()
        }

        result.append(NSAttributedString(string: text, attributes: styleStack.attributes()))
    }
    
    func renderList(_ info: ListInfo, items: [ListItem], indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.list(isTight: info.isTight))
        defer {
            styleStack.pop()
        }
        
        for (index, item) in items.enumerated() {
            render(item, info: info, index: index, indent: indent, with: styleStack, into: result)
        }
    }
    
    func renderListItemMarker(_ index: Int, info: ListInfo, indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        switch info.kind {
        case .bulleted:
            let format = styleStack.attributes()[.unorderedListMarkerFormat] as? UnorderedListMarkerFormatValue ?? UnorderedListMarkerFormatValue(format: .bullet)
            let baseString = format.render()
            let startLocation = result.length
            result.append(baseString)
            result.addAttributes(styleStack.attributes(),
                                 range: NSRange(location: startLocation, length: result.length - startLocation))
        case let .ordered(start: start):
            let format = styleStack.attributes()[.orderedListMarkerFormat] as? OrderedListMarkerFormatValue
                ?? OrderedListMarkerFormatValue(format: .arabicNumeral, prefix: "", suffix: ".")
            let rawText = format.render(start + index)
            result.append(NSAttributedString(string: rawText, attributes: styleStack.attributes()))
        }
    }
    
    func render(_ item: ListItem, info: ListInfo, index: Int, indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        renderListItemMarker(index, info: info, indent: indent, with: styleStack, into: result)
                
        styleStack.push(.item, rawAttributes: [.leadingMarginIndent: indent + 1])
        defer {
            styleStack.pop()
        }
        
        result.append(NSAttributedString(string: "\t", attributes: styleStack.attributes()))
        
        for element in item.elements {
            render(element, indent: indent + 1, with: styleStack, into: result)
        }
    }
    
    func render(_ text: [InlineText], with styleStack: StyleStack, into result: NSMutableAttributedString) {
        for element in text {
            render(element, with: styleStack, into: result)
        }
    }

    func render(_ text: InlineText, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        switch text {
        case let .code(code):
            renderCode(code.code.text, with: styleStack, into: result)
        case let .text(text):
            renderText(text.text, with: styleStack, into: result)
        case .linebreak:
            renderLinebreak(with: styleStack, into: result)
        case let .link(link):
            renderLink(link.link, text: link.text, with: styleStack, into: result)
        case let .image(image):
            renderImage(image.link, altText: image.alt.text, with: styleStack, into: result)
        case let .emphasis(text):
            renderEmphasis(text.text, with: styleStack, into: result)
        case let .strong(text):
            renderStrong(text.text, with: styleStack, into: result)
        case let .strikethrough(text):
            renderStrikethrough(text.text, with: styleStack, into: result)
        case .softbreak:
            renderSoftbreak(with: styleStack, into: result)
        }
    }
    
    func renderCode(_ text: String, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.code)
        defer {
            styleStack.pop()
        }
        
        result.append(NSAttributedString(string: text, attributes: styleStack.attributes()))
    }
    
    func renderText(_ text: String, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: text, attributes: styleStack.attributes()))
    }

    func renderLinebreak(with styleStack: StyleStack, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: "\r", attributes: styleStack.attributes()))
    }

    func renderSoftbreak(with styleStack: StyleStack, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: " ", attributes: styleStack.attributes()))
    }

    func renderLink(_ link: Link?, text: [InlineText], with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.link)
        defer {
            styleStack.pop()
        }
        
        var attributes = [NSAttributedString.Key: Any]()
        if let url = link?.url.flatMap({ NSURL(string: $0.text) }) {
            attributes[.nativeMarkLink] = url
        }
        if let title = link?.title {
            #if os(macOS)
            attributes[.toolTip] = title
            #endif
        }

        let startLocation = result.length
        render(text, with: styleStack, into: result)
        result.addAttributes(attributes, range: NSRange(location: startLocation, length: result.length - startLocation))
    }
    
    func renderImage(_ link: Link?, altText: String, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        var attributes = [NSAttributedString.Key: Any]()
        #if os(macOS)
        attributes[.toolTip] = altText
        #endif

        styleStack.push(.image, rawAttributes: attributes)
        defer {
            styleStack.pop()
        }

        let attachment = ImageTextAttachment(imageUrl: link?.url?.text, delegate: styleStack.stylesheet)
        renderTextAttachment(attachment, with: styleStack, into: result)
    }

    func renderEmphasis(_ text: [InlineText], with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.emphasis)
        defer {
            styleStack.pop()
        }

        render(text, with: styleStack, into: result)
    }

    func renderStrong(_ text: [InlineText], with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.strong)
        defer {
            styleStack.pop()
        }

        render(text, with: styleStack, into: result)
    }

    func renderStrikethrough(_ text: [InlineText], with styleStack: StyleStack, into result: NSMutableAttributedString) {
        styleStack.push(.strikethrough)
        defer {
            styleStack.pop()
        }

        render(text, with: styleStack, into: result)
    }

    func renderNewline(with styleStack: StyleStack, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: "\n", attributes: styleStack.attributes()))
    }
    
    func renderTextAttachment(_ textAttachment: NSTextAttachment, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        let startLocation = result.length
        result.append(NSAttributedString(attachment: textAttachment))
        result.addAttributes(styleStack.attributes(), range: NSRange(location: startLocation, length: result.length - startLocation))
    }
    
    func insertSpacer(_ length: Length, at characterIndex: Int, in result: NSMutableAttributedString) {
        let defaultFont = self.defaultFont(at: characterIndex, in: result)
        let lengthInPoints = length.asRawPoints(for: defaultFont.pointSize)
        let attachment = SpacerAttachment(lengthInPoints: lengthInPoints)
        result.insert(NSAttributedString(attachment: attachment), at: characterIndex)
    }
    
    func defaultFont(at characterIndex: Int, in result: NSMutableAttributedString) -> NativeFont {
        let limitedCharacterIndex = max(min(characterIndex, result.length - 1), 0)
        return result.attribute(.font, at: limitedCharacterIndex, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()
    }
}
