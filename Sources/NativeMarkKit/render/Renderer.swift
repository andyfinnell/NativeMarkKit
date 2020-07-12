import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#elseif canImport(WatchKit)
import WatchKit
#else
#error("Unsupported platform")
#endif

struct Renderer {
    func render(_ document: Document, with stylesheet: StyleSheet) -> NSAttributedString {
        let styleStack = StyleStack(stylesheet: stylesheet)
        styleStack.push(.document)
        defer {
            styleStack.pop()
        }
        return render(document.elements, with: styleStack)
    }
}

private extension Renderer {
    func render(_ elements: [Element], with styleStack: StyleStack) -> NSAttributedString {
        elements.reduce(into: NSMutableAttributedString()) { sum, element in
            sum.append(render(element, with: styleStack))
        }
    }
    
    func render(_ element: Element, with styleStack: StyleStack) -> NSAttributedString {
        switch element {
        case let .paragraph(text):
            return renderParagraph(text, with: styleStack)
        case .thematicBreak:
            return renderThematicBreak(with: styleStack)
        case let .heading(level: level, text: text):
            return renderHeading(level: level, text: text, with: styleStack)
        case let .blockQuote(elements):
            return renderBlockQuote(elements, with: styleStack)
        case let .codeBlock(infoString: infoString, content: text):
            return renderCodeBlock(info: infoString, text: text, with: styleStack)
        case let .list(info, items: items):
            return renderList(info, items: items, with: styleStack)
        }
    }
    
    func renderParagraph(_ text: [InlineText], with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.paragraph)
        defer {
            styleStack.pop()
        }
        
        return render(text, with: styleStack)
    }
    
    func renderThematicBreak(with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.thematicBreak)
        defer {
            styleStack.pop()
        }
        
        // TODO: use an image for thematic break?
        return NSAttributedString(string: "---", attributes: styleStack.attributes())
    }
    
    func renderHeading(level: Int, text: [InlineText], with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.heading(level: level))
        defer {
            styleStack.pop()
        }

        return render(text, with: styleStack)
    }
        
    func renderBlockQuote(_ elements: [Element], with styleStack: StyleStack) -> NSAttributedString {
        // TODO: how to render this? indent and change text color?
        styleStack.push(.blockQuote)
        defer {
            styleStack.pop()
        }
        
        return render(elements, with: styleStack)
    }

    func renderCodeBlock(info: String, text: String, with styleStack: StyleStack) -> NSAttributedString {
        // TODO: how to render this? change font? background color?
        // TODO: delegate out so let a more sophisticated renderer do syntax highlighting
        styleStack.push(.codeBlock)
        defer {
            styleStack.pop()
        }

        return NSAttributedString(string: text, attributes: styleStack.attributes())
    }
    
    func renderList(_ info: ListInfo, items: [ListItem], with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.list(isTight: info.isTight))
        defer {
            styleStack.pop()
        }
        
        // TODO: are there attributes specific to lists?
        
        return items.enumerated().reduce(into: NSMutableAttributedString()) { sum, iAndItem in
            let (index, item) = iAndItem
            sum.append(render(item, info: info, index: index, with: styleStack))
        }
    }
    
    func renderListItemMarker(_ index: Int, info: ListInfo, with styleStack: StyleStack) -> NSAttributedString {
        let rawText: String
        switch info.kind {
        case .bulleted:
            rawText = "•" // TODO: allow this to be an image
        case let .ordered(start: start):
            rawText = String(describing: start + index)
        }
        return NSAttributedString(string: rawText + " ", attributes: styleStack.attributes())
    }
    
    func render(_ item: ListItem, info: ListInfo, index: Int, with styleStack: StyleStack) -> NSAttributedString {
        let marker = renderListItemMarker(index, info: info, with: styleStack)
                
        styleStack.push(.item)
        defer {
            styleStack.pop()
        }

        let result = NSMutableAttributedString()
        result.append(marker)
        return item.elements.reduce(into: result) { sum, element in
            sum.append(render(element, with: styleStack))
        }
    }
    
    func render(_ text: [InlineText], with styleStack: StyleStack) -> NSAttributedString {
        text.reduce(into: NSMutableAttributedString()) { sum, element in
            sum.append(render(element, with: styleStack))
        }
    }

    func render(_ text: InlineText, with styleStack: StyleStack) -> NSAttributedString {
        switch text {
        case let .code(text):
            return renderCode(text, with: styleStack)
        case let .text(text):
            return renderText(text, with: styleStack)
        case .linebreak:
            return renderLinebreak(with: styleStack)
        case let .link(link, text: content):
            return renderLink(link, text: content, with: styleStack)
        case let .image(link, alt: altText):
            return renderImage(link, altText: altText, with: styleStack)
        case let .emphasis(text):
            return renderEmphasis(text, with: styleStack)
        case let .strong(text):
            return renderStrong(text, with: styleStack)
        case .softbreak:
            return NSAttributedString()
        }
    }
    
    func renderCode(_ text: String, with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.code)
        defer {
            styleStack.pop()
        }
        return NSAttributedString(string: text, attributes: styleStack.attributes())
    }
    
    func renderText(_ text: String, with styleStack: StyleStack) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: styleStack.attributes())
    }

    func renderLinebreak(with styleStack: StyleStack) -> NSAttributedString {
        return NSAttributedString(string: "\n", attributes: styleStack.attributes())
    }

    func renderLink(_ link: Link?, text: [InlineText], with styleStack: StyleStack) -> NSAttributedString {
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

        let result = NSMutableAttributedString(attributedString: render(text, with: styleStack))
        result.addAttributes(attributes, range: NSRange(location: 0, length: result.string.count))
        return result
    }
    
    func renderImage(_ link: Link?, altText: String, with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.image)
        defer {
            styleStack.pop()
        }

        let attachment = NSTextAttachment()
        // TODO: retreive image. Maybe force a cache to be provided beforehand?
        
        let result = NSMutableAttributedString(attributedString:  NSAttributedString(attachment: attachment))
        result.addAttributes(styleStack.attributes(), range: NSRange(location: 0, length: result.string.count))
        return result
    }

    func renderEmphasis(_ text: [InlineText], with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.emphasis)
        defer {
            styleStack.pop()
        }

        return render(text, with: styleStack)
    }

    func renderStrong(_ text: [InlineText], with styleStack: StyleStack) -> NSAttributedString {
        styleStack.push(.strong)
        defer {
            styleStack.pop()
        }

        return render(text, with: styleStack)
    }
}
