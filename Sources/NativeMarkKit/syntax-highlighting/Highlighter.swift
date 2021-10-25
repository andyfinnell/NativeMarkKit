import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

protocol HighlightedSource {
    var length: Int { get }
    
    func setAttributes(_ attributes: [NSAttributedString.Key: Any]?, range: NSRange)
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange)

    func textRange(_ range: TextRange?) -> NSRange?
}

struct Highlighter {
    
    func highlight(_ result: HighlightedSource, using document: Document, with stylesheet: StyleSheet) {
        let styleStack = StyleStack(stylesheet: stylesheet)
        styleStack.push(.document)
        defer {
            styleStack.pop()
        }
        
        result.setAttributes(styleStack.attributes(), range: NSRange(location: 0, length: result.length))

        highlight(document.elements, indent: 0, with: styleStack, in: result)
                
        highlight(document.linkDefinitions, with: styleStack, in: result)
    }
}

private extension Highlighter {
    func highlight(_ elements: [Element], indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        for element in elements {
            highlight(element, indent: indent, with: styleStack, in: result)
        }
    }
    
    func highlight(_ element: Element, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        switch element {
        case let .paragraph(paragraph):
            highlight(paragraph, indent: indent, with: styleStack, in: result)
        case let .thematicBreak(thematicBreak):
            highlight(thematicBreak, with: styleStack, in: result)
        case let .heading(heading):
            highlight(heading, indent: indent, with: styleStack, in: result)
        case let .blockQuote(blockQuote):
            highlight(blockQuote, indent: indent, with: styleStack, in: result)
        case let .codeBlock(codeBlock):
            highlight(codeBlock, indent: indent, with: styleStack, in: result)
        case let .list(list):
            highlight(list, indent: indent, with: styleStack, in: result)
        }
    }
    
    func highlight(_ paragraph: Paragraph, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.paragraph)
        defer {
            styleStack.pop()
        }
        
        highlight(paragraph.text, with: styleStack, in: result)
    }
    
    func highlight(_ thematicBreak: ThematicBreak, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.thematicBreak)
        defer {
            styleStack.pop()
        }
        
        highlight(thematicBreak.range, with: styleStack, in: result)
    }
    
    func highlight(_ heading: Heading, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.heading(level: heading.level))
        defer {
            styleStack.pop()
        }

        highlight(heading.range, with: styleStack, in: result)
        highlight(heading.text, with: styleStack, in: result)
    }
        
    func highlight(_ blockQuote: BlockQuote, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.blockQuote)
        defer {
            styleStack.pop()
        }
        
        highlight(blockQuote.range, with: styleStack, in: result)
        highlight(blockQuote.blocks, indent: indent + 1, with: styleStack, in: result)
    }

    func highlight(_ codeBlock: CodeBlock, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.codeBlock)
        defer {
            styleStack.pop()
        }

        highlight(codeBlock.range, with: styleStack, in: result)
    }
    
    func highlight(_ list: List, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.list(isTight: list.info.isTight))
        defer {
            styleStack.pop()
        }
        
        for (index, item) in list.items.enumerated() {
            highlight(item, info: list.info, index: index, indent: indent, with: styleStack, in: result)
        }
    }
        
    func highlight(_ item: ListItem, info: ListInfo, index: Int, indent: Int, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.item)
        defer {
            styleStack.pop()
        }
        
        highlight(item.range, with: styleStack, in: result)
        for element in item.elements {
            highlight(element, indent: indent + 1, with: styleStack, in: result)
        }
    }
    
    func highlight(_ text: [InlineText], with styleStack: StyleStack, in result: HighlightedSource) {
        for element in text {
            highlight(element, with: styleStack, in: result)
        }
    }

    func highlight(_ text: InlineText, with styleStack: StyleStack, in result: HighlightedSource) {
        switch text {
        case let .code(code):
            highlight(code, with: styleStack, in: result)
        case let .text(text):
            highlight(text, with: styleStack, in: result)
        case let .linebreak(linebreak):
            highlight(linebreak, with: styleStack, in: result)
        case let .link(link):
            highlight(link, with: styleStack, in: result)
        case let .image(image):
            highlight(image, with: styleStack, in: result)
        case let .emphasis(text):
            highlight(text, with: styleStack, in: result)
        case let .strong(text):
            highlight(text, with: styleStack, in: result)
        case let .softbreak(softbreak):
            highlight(softbreak, with: styleStack, in: result)
        }
    }
    
    func highlight(_ code: InlineCode, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.code)
        defer {
            styleStack.pop()
        }
        
        highlight(code.range, with: styleStack, in: result)
    }
    
    func highlight(_ text: InlineString, with styleStack: StyleStack, in result: HighlightedSource) {
        // TODO: nop?
    }

    func highlight(_ linebreak: InlineLinebreak, with styleStack: StyleStack, in result: HighlightedSource) {
        // TODO: nop?
    }

    func highlight(_ softbreak: InlineSoftbreak, with styleStack: StyleStack, in result: HighlightedSource) {
        // TODO: nop?
    }

    func highlight(_ link: InlineLink, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.link)
        defer {
            styleStack.pop()
        }
        
        highlight(link.range, with: styleStack, in: result)
        highlight(link.text, with: styleStack, in: result)
    }
    
    func highlight(_ image: InlineImage, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.image)
        defer {
            styleStack.pop()
        }

        highlight(image.range, with: styleStack, in: result)
    }

    func highlight(_ emphasis: InlineEmphasis, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.emphasis)
        defer {
            styleStack.pop()
        }

        highlight(emphasis.range, with: styleStack, in: result)
        highlight(emphasis.text, with: styleStack, in: result)
    }

    func highlight(_ strong: InlineStrong, with styleStack: StyleStack, in result: HighlightedSource) {
        styleStack.push(.strong)
        defer {
            styleStack.pop()
        }

        highlight(strong.range, with: styleStack, in: result)
        highlight(strong.text, with: styleStack, in: result)
    }

    func highlight(_ linkDefinitions: [LinkDefinition], with styleStack: StyleStack, in result: HighlightedSource) {
        for def in linkDefinitions {
            highlight(def, with: styleStack, in: result)
        }
    }
    
    func highlight(_ linkDefinition: LinkDefinition, with styleStack: StyleStack, in result: HighlightedSource) {
        // TODO: need selector for link definitions
    }
    
    func highlight(_ range: TextRange?, with styleStack: StyleStack, in result: HighlightedSource) {
        guard let nsRange = result.textRange(range) else { return }
        
        result.addAttributes(styleStack.attributes(), range: nsRange)
    }
}
