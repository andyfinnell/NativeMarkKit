import Foundation

struct CloseBracketParser {
    
    func parse(_ input: TextCursor, with delimiterStack: DelimiterStack, linkDefs: [LinkLabel: LinkDefinition]) -> TextResult<InlineText?> {
        let closeBracket = input.parse("]")
        guard closeBracket.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        guard let openBracket = delimiterStack.openBracket() else {
            return closeBracket.map { .text(InlineString(text: $0, range: closeBracket.valueTextRange)) }
        }
        
        guard openBracket.isActive else {
            delimiterStack.demoteDelimiter(openBracket)
            return closeBracket.map { .text(InlineString(text: $0, range: closeBracket.valueTextRange)) }
        }
        
        let unknownLinkResult = parseLinkOrRef(closeBracket.remaining,
                                               linkDefs: linkDefs,
                                               openingBracket: openBracket)
        
        guard let unknownLink = unknownLinkResult.value else {
            delimiterStack.demoteDelimiter(openBracket)
            return closeBracket.map { .text(InlineString(text: $0, range: closeBracket.valueTextRange)) }
        }
        
        let link = unknownLink.link
        let isImage = openBracket.isImageOpener
        
        let substack = delimiterStack.popSubstack(starting: openBracket)
        substack.processEmphasis()
        let contents = substack.inlineText
        let range = TextRange(start: openBracket.startCursor, end: unknownLinkResult.remaining.retreat())
        let inlineText = isImage
            ? InlineText.image(InlineImage(link: link, alt: InlineString(text: plainText(contents), range: contents.range), range: range))
            : .link(InlineLink(link: link, text: contents, range: range))
                
        if openBracket.isLinkOpener {
            delimiterStack.deactivateLinkOpeners()
        }
        
        return TextResult(remaining: unknownLinkResult.remaining,
                          value: inlineText,
                          valueLocation: openBracket.startCursor,
                          valueTextRange: range)
    }
}

private extension CloseBracketParser {
    enum UnknownLink {
        case invalid
        case valid(Link)
        
        var link: Link? {
            switch self {
            case .invalid: return nil
            case let .valid(l): return l
            }
        }
    }
    
    func parseLinkOrRef(_ input: TextCursor, linkDefs: [LinkLabel: LinkDefinition], openingBracket: Delimiter) -> TextResult<UnknownLink?> {
        let inlineLinkResult = InlineLinkParser().parse(input)
        if let link = inlineLinkResult.value {
            return inlineLinkResult.map { _ in .valid(link) }
        }
        
        let linkRefResult = parseLinkReference(input,
                                               linkDefs: linkDefs,
                                               openingBracket: openingBracket)
        if linkRefResult.value != nil {
            return linkRefResult
        }
        
        return input.noMatch(nil)
    }
    
    func parseLinkReference(_ input: TextCursor, linkDefs: [LinkLabel: LinkDefinition], openingBracket: Delimiter) -> TextResult<UnknownLink?> {
        let linkLabelResult = LinkLabelParser().parse(input)        
        let linkLabel: LinkLabel?
        if linkLabelResult.value.count > 2 {
            linkLabel = LinkLabel(linkLabelResult.value)
        } else {
            // Either there's no label or it's empty. In that case, we want to
            //  use the "content" of the link as the label. However, the rule
            //  says that it's not allowed to have a bracket in it
            let starting = openingBracket.startCursor == "!" ? openingBracket.startCursor.advance() : openingBracket.startCursor
            let potentialLabel = LinkLabel(starting.substring(upto: input))
            linkLabel = potentialLabel.value.contains("[") ? nil : potentialLabel
        }
        
        guard let label = linkLabel else {
            return input.noMatch(nil)
        }
        
        if let link = linkDefs[label] {
            return linkLabelResult.map { _ in .valid(link.link) }
        } else {
            return input.noMatch(nil)
        }
    }
    
    func plainText(_ inlineText: [InlineText]) -> String {
        inlineText.reduce("") { sum, inline in
            switch inline {
            case let .text(t):
                return sum + t.text
            case let .code(t):
                return sum + t.code.text
            case .linebreak,
                 .softbreak:
                return sum
            case let .image(image):
                return sum + image.alt.text
            case let .link(link):
                return sum + plainText(link.text)
            case let .emphasis(t):
                return sum + plainText(t.text)
            case let .strong(t):
                return sum + plainText(t.text)
            }
        }
    }
}
