import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

class Renderer {
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
                
        return result
    }
}

private extension Renderer {    
    func render(_ elements: [Element], indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        for element in elements {
            render(element, indent: indent, with: styleStack, into: result)
        }
    }
    
    func render(_ element: Element, indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        switch element {
        case let .paragraph(text):
            renderParagraph(text, indent: indent, with: styleStack, into: result)
        case .thematicBreak:
            renderThematicBreak(with: styleStack, into: result)
        case let .heading(level: level, text: text):
            renderHeading(level: level, text: text, indent: indent, with: styleStack, into: result)
        case let .blockQuote(elements):
            renderBlockQuote(elements, indent: indent, with: styleStack, into: result)
        case let .codeBlock(infoString: infoString, content: text):
            renderCodeBlock(info: infoString, text: text, indent: indent, with: styleStack, into: result)
        case let .list(info, items: items):
            renderList(info, items: items, indent: indent, with: styleStack, into: result)
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
        
        // TODO: use an image for thematic break?
        result.append(NSAttributedString(string: "---", attributes: styleStack.attributes()))
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
        // TODO: how to render this? indent and change text color?
        styleStack.push(.blockQuote)
        defer {
            styleStack.pop()
        }
        
        render(elements, indent: indent + 1, with: styleStack, into: result)
    }

    func renderCodeBlock(info: String, text: String, indent: Int, with styleStack: StyleStack, into result: NSMutableAttributedString) {
        // TODO: how to render this? change font? background color?
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
            let format = styleStack.attributes()[.orderedListMarkerFormat] as? OrderedListMarkerFormatValue ?? OrderedListMarkerFormatValue(format: .arabicNumeral, separator: ".")
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
        case let .code(text):
            renderCode(text, with: styleStack, into: result)
        case let .text(text):
            renderText(text, with: styleStack, into: result)
        case .linebreak:
            renderLinebreak(with: styleStack, into: result)
        case let .link(link, text: content):
            renderLink(link, text: content, with: styleStack, into: result)
        case let .image(link, alt: altText):
            renderImage(link, altText: altText, with: styleStack, into: result)
        case let .emphasis(text):
            renderEmphasis(text, with: styleStack, into: result)
        case let .strong(text):
            renderStrong(text, with: styleStack, into: result)
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
        renderNewline(with: styleStack, into: result)
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
        if let url = link.flatMap({ NSURL(string: $0.url) }) {
            attributes[.link] = url
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
        styleStack.push(.image)
        defer {
            styleStack.pop()
        }

        let attachment = NSTextAttachment()
        // TODO: retreive image. Maybe force a cache to be provided beforehand?
        let attachmentString = NSAttributedString(attachment: attachment)
        let startLocation = result.length
        result.append(attachmentString)
        result.addAttributes(styleStack.attributes(), range: NSRange(location: startLocation, length: attachmentString.length))
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
        
    func renderNewline(with styleStack: StyleStack, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: "\n", attributes: styleStack.attributes()))
    }
}
