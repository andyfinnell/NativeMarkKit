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
    
    func render(_ document: Document, with stylesheet: StyleSheet, environment: Environment) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let state = State(stylesheet: stylesheet, environment: environment)
        state.push(.document)
        defer {
            state.pop()
        }
        render(document.elements, indent: 0, with: state, into: result)
        
        if result.string.hasSuffix("\n") {
            result.deleteCharacters(in: NSRange(location: result.length - 1, length: 1))
        }
        
        fixInlineBackgroundSpacing(in: result)
        
        return result
    }
}

private extension Renderer {

    final class State {
        var path = [ContainerKind]()
        var hasRenderedFirstContainerBreak = false
        let styleStack: StyleStack
        let environment: Environment
        
        init(stylesheet: StyleSheet, environment: Environment) {
            styleStack = StyleStack(stylesheet: stylesheet)
            self.environment = environment
        }
        
        func push(_ blockSelector: BlockStyleSelector, rawAttributes: [NSAttributedString.Key: Any] = [:]) {
            styleStack.push(blockSelector, rawAttributes: rawAttributes)
        }
        
        func push(_ inlineSelector: InlineStyleSelector, rawAttributes: [NSAttributedString.Key: Any] = [:]) {
            styleStack.push(inlineSelector, rawAttributes: rawAttributes)
        }
        
        func pop() {
            styleStack.pop()
        }
        
        func attributes() -> [NSAttributedString.Key: Any] {
            styleStack.attributes()
        }
    }
    
    func enterContainer(_ containerKind: ContainerKind, with state: State, in result: NSMutableAttributedString) {
        switch containerKind {
        case .leaf:
            // Leafs are rendered text content. If we already have one open, keep
            //  using it. Only create a new one if we don't already have one.
            if state.path.last != .leaf {
                state.path.append(.leaf)
                renderContainerBreak(true, with: state, in: result)
            }
            
        case .listItemMarker,
                .codeBlock:
            // An item market needs its own container, so special case it
            if state.path.last == .leaf {
                state.path.removeLast()
            }
            state.path.append(containerKind)
            renderContainerBreak(true, with: state, in: result)

        case .blockQuote,
                .list,
                .listItem,
                .listItemContent:
            // These will create new layouts, but don't have any direct content
            //  themselves. Therefore, they don't create container breaks.
            if state.path.last == .leaf {
                state.path.removeLast()
            }
            state.path.append(containerKind)
            renderContainerBreak(false, with: state, in: result)
        }
    }

    func exitContainer(_ containerKind: ContainerKind, with state: State, in result: NSMutableAttributedString) {
        switch containerKind {
        case .leaf:
            break // nop, since we want to coalesce these
        case .blockQuote,
                .list,
                .listItem,
                .listItemMarker,
                .listItemContent,
                .codeBlock:
            if let index = state.path.lastIndex(of: containerKind) {
                state.path.removeSubrange(index..<state.path.endIndex)
            }
        }
    }

    func renderContainerBreak(_ needsRealContainerBreak: Bool, with state: State, in result: NSMutableAttributedString) {
        let pageBreakString = String(UnicodeScalar(12))
        let shouldContainerBreak = state.hasRenderedFirstContainerBreak && needsRealContainerBreak
        if needsRealContainerBreak {
            state.hasRenderedFirstContainerBreak = true
        }
        let attributeValue = ContainerBreakValue(path: state.path, shouldContainerBreak: shouldContainerBreak)
        
        // TODO: this is wrong. If not at index=0, then copy attributes from previous index
        //  If at index=0, then what?
        var attributes: [NSAttributedString.Key: Any]
        if result.length == 0 {
            attributes = state.attributes()
        } else {
             attributes = result.attributes(at: result.length - 1, effectiveRange: nil)
        }
        attributes[.containerBreak] = attributeValue
        result.append(NSAttributedString(string: pageBreakString, attributes: attributes))
    }
    
    func fixInlineBackgroundSpacing(in result: NSMutableAttributedString) {
        result.enumerateAttribute(.inlineBackground, in: NSRange(location: 0, length: result.length), options: .reverse) { value, characterRange, _ in
            guard let background = value as? InlineBackgroundValue else { return }
            
            insertSpacer(background.rightMargin, at: characterRange.upperBound, in: result)
            insertSpacer(background.leftMargin, at: characterRange.lowerBound, in: result)
        }
    }
    
    func render(_ elements: [Element], indent: Int, with state: State, into result: NSMutableAttributedString) {
        for element in elements {
            render(element, indent: indent, with: state, into: result)
        }
    }
    
    func render(_ element: Element, indent: Int, with state: State, into result: NSMutableAttributedString) {
        switch element {
        case let .paragraph(paragraph):
            renderParagraph(paragraph.text, indent: indent, with: state, into: result)
        case .thematicBreak:
            renderThematicBreak(with: state, into: result)
        case let .heading(heading):
            renderHeading(level: heading.level, text: heading.text, indent: indent, with: state, into: result)
        case let .blockQuote(blockQuote):
            renderBlockQuote(blockQuote.blocks, indent: indent, with: state, into: result)
        case let .codeBlock(codeBlock):
            renderCodeBlock(info: codeBlock.infoString, text: codeBlock.content, indent: indent, with: state, into: result)
        case let .list(list):
            renderList(list.info, items: list.items, indent: indent, with: state, into: result)
        }
    }
    
    func renderParagraph(_ text: [InlineText], indent: Int, with state: State, into result: NSMutableAttributedString) {
        state.push(.paragraph)
        defer {
            state.pop()
        }
        
        enterContainer(.leaf, with: state, in: result)
        
        render(text, with: state, into: result)
        renderNewline(with: state, into: result)
        
        exitContainer(.leaf, with: state, in: result)
    }
    
    func renderThematicBreak(with state: State, into result: NSMutableAttributedString) {
        state.push(.thematicBreak)
        defer {
            state.pop()
        }
        
        let attributes = state.attributes()
        let thickness = attributes[.thematicBreakThickness] as? CGFloat ?? 1.0
        let color = attributes[.thematicBreakColor] as? NativeColor ?? .adaptableSeparatorColor
        let attachment = ThematicBreakAttachment(thickness: thickness, color: color)
        
        enterContainer(.leaf, with: state, in: result)

        renderTextAttachment(attachment, with: state, into: result)
        renderNewline(with: state, into: result)
        
        exitContainer(.leaf, with: state, in: result)
    }
    
    func renderHeading(level: Int, text: [InlineText], indent: Int, with state: State, into result: NSMutableAttributedString) {
        state.push(.heading(level: level))
        defer {
            state.pop()
        }

        enterContainer(.leaf, with: state, in: result)

        render(text, with: state, into: result)
        renderNewline(with: state, into: result)
        
        exitContainer(.leaf, with: state, in: result)
    }
        
    func renderBlockQuote(_ elements: [Element], indent: Int, with state: State, into result: NSMutableAttributedString) {
        state.push(.blockQuote)
        defer {
            state.pop()
        }
        
        let style = textContainerStyle(from: state)

        enterContainer(.blockQuote(style), with: state, in: result)

        render(elements, indent: indent + 1, with: state, into: result)
        
        exitContainer(.blockQuote(style), with: state, in: result)
    }

    func textContainerStyle(from state: State) -> TextContainerStyle {
        let attrs = state.attributes()
        let marginValue = attrs[.blockMargin] as? MarginValue
        let borderValue = attrs[.blockBorder] as? BorderValue
        let paddingValue = attrs[.blockPadding] as? PaddingValue
        let backgroundValue = attrs[.blockBackground] as? NativeColor
        return TextContainerStyle(margin: marginValue?.margin,
                                  border: borderValue?.border,
                                  padding: paddingValue?.padding,
                                  backgroundColor: backgroundValue)
    }
    
    func renderCodeBlock(info: String, text: String, indent: Int, with state: State, into result: NSMutableAttributedString) {
        // TODO: delegate out so let a more sophisticated renderer do syntax highlighting
        state.push(.codeBlock)
        defer {
            state.pop()
        }

        let style = textContainerStyle(from: state)

        enterContainer(.codeBlock(style), with: state, in: result)

        result.append(NSAttributedString(string: text, attributes: state.attributes()))
        
        exitContainer(.codeBlock(style), with: state, in: result)
    }
    
    func renderList(_ info: ListInfo, items: [ListItem], indent: Int, with state: State, into result: NSMutableAttributedString) {
        state.push(.list(isTight: info.isTight))
        defer {
            state.pop()
        }
        
        let listValue = state.attributes()[.list] as? ListValue ?? ListValue()

        enterContainer(.list(listValue), with: state, in: result)

        for (index, item) in items.enumerated() {
            render(item, info: info, index: index, indent: indent, with: state, into: result)
        }
        
        exitContainer(.list(listValue), with: state, in: result)
    }
    
    func renderListItemMarker(_ index: Int, item: ListItem, info: ListInfo, indent: Int, with state: State, into result: NSMutableAttributedString) {
        enterContainer(.listItemMarker, with: state, in: result)
        
        if case .paragraph(let p) = item.elements.first, let taskListItemMark = p.taskListItemMark {
            let isChecked = taskListItemMark.contentText != " "
            let attachment = TaskItemTextAttachment(isChecked: isChecked)
            let startLocation = result.length
            result.append(NSAttributedString(attachment: attachment))
            result.addAttributes(state.attributes(),
                                 range: NSRange(location: startLocation, length: result.length - startLocation))

        } else {
            switch info.kind {
            case .bulleted:
                let format = state.attributes()[.unorderedListMarkerFormat] as? UnorderedListMarkerFormatValue ?? UnorderedListMarkerFormatValue(format: .bullet)
                let baseString = format.render()
                let startLocation = result.length
                result.append(baseString)
                result.addAttributes(state.attributes(),
                                     range: NSRange(location: startLocation, length: result.length - startLocation))
            case let .ordered(start: start):
                let format = state.attributes()[.orderedListMarkerFormat] as? OrderedListMarkerFormatValue
                ?? OrderedListMarkerFormatValue(format: .arabicNumeral, prefix: "", suffix: ".")
                let rawText = format.render(start + index)
                result.append(NSAttributedString(string: rawText, attributes: state.attributes()))
                
            }
        }
        
        exitContainer(.listItemMarker, with: state, in: result)
    }
    
    func render(_ item: ListItem, info: ListInfo, index: Int, indent: Int, with state: State, into result: NSMutableAttributedString) {
        enterContainer(.listItem, with: state, in: result)
        
        renderListItemMarker(index, item: item, info: info, indent: indent, with: state, into: result)
                
        state.push(.item)
        defer {
            state.pop()
        }
        
        enterContainer(.listItemContent, with: state, in: result)
        
        for element in item.elements {
            render(element, indent: indent + 1, with: state, into: result)
        }
        exitContainer(.listItemContent, with: state, in: result)
        exitContainer(.listItem, with: state, in: result)
    }
    
    func render(_ text: [InlineText], with state: State, into result: NSMutableAttributedString) {
        for element in text {
            render(element, with: state, into: result)
        }
    }

    func render(_ text: InlineText, with state: State, into result: NSMutableAttributedString) {
        switch text {
        case let .code(code):
            renderCode(code.code.text, with: state, into: result)
        case let .text(text):
            renderText(text.text, with: state, into: result)
        case .linebreak:
            renderLinebreak(with: state, into: result)
        case let .link(link):
            renderLink(link.link, text: link.text, with: state, into: result)
        case let .image(image):
            renderImage(image.link, altText: image.alt.text, with: state, into: result)
        case let .emphasis(text):
            renderEmphasis(text.text, with: state, into: result)
        case let .strong(text):
            renderStrong(text.text, with: state, into: result)
        case let .strikethrough(text):
            renderStrikethrough(text.text, with: state, into: result)
        case .softbreak:
            renderSoftbreak(with: state, into: result)
        }
    }
    
    func renderCode(_ text: String, with state: State, into result: NSMutableAttributedString) {
        state.push(.code)
        defer {
            state.pop()
        }
        
        result.append(NSAttributedString(string: text, attributes: state.attributes()))
    }
    
    func renderText(_ text: String, with state: State, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: text, attributes: state.attributes()))
    }

    func renderLinebreak(with state: State, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: "\r", attributes: state.attributes()))
    }

    func renderSoftbreak(with state: State, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: " ", attributes: state.attributes()))
    }

    func renderLink(_ link: Link?, text: [InlineText], with state: State, into result: NSMutableAttributedString) {
        state.push(.link)
        defer {
            state.pop()
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
        render(text, with: state, into: result)
        result.addAttributes(attributes, range: NSRange(location: startLocation, length: result.length - startLocation))
    }
    
    func renderImage(_ link: Link?, altText: String, with state: State, into result: NSMutableAttributedString) {
        var attributes = [NSAttributedString.Key: Any]()
        #if os(macOS)
        attributes[.toolTip] = altText
        #endif

        state.push(.image, rawAttributes: attributes)
        defer {
            state.pop()
        }

        let attachment = ImageTextAttachment(imageUrl: link?.url?.text, environment: state.environment)
        renderTextAttachment(attachment, with: state, into: result)
    }

    func renderEmphasis(_ text: [InlineText], with state: State, into result: NSMutableAttributedString) {
        state.push(.emphasis)
        defer {
            state.pop()
        }

        render(text, with: state, into: result)
    }

    func renderStrong(_ text: [InlineText], with state: State, into result: NSMutableAttributedString) {
        state.push(.strong)
        defer {
            state.pop()
        }

        render(text, with: state, into: result)
    }

    func renderStrikethrough(_ text: [InlineText], with state: State, into result: NSMutableAttributedString) {
        state.push(.strikethrough)
        defer {
            state.pop()
        }

        render(text, with: state, into: result)
    }

    func renderNewline(with state: State, into result: NSMutableAttributedString) {
        result.append(NSAttributedString(string: "\n", attributes: state.attributes()))
    }
    
    func renderTextAttachment(_ textAttachment: NSTextAttachment, with state: State, into result: NSMutableAttributedString) {
        let startLocation = result.length
        result.append(NSAttributedString(attachment: textAttachment))
        result.addAttributes(state.attributes(), range: NSRange(location: startLocation, length: result.length - startLocation))
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
