import Foundation

struct AutolinkParser {
    private static let emailAutolinkRegex = try! NSRegularExpression(pattern: "^<([a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>", options: [])
    private static let autolinkRegex = try! NSRegularExpression(pattern: "^<[A-Za-z][A-Za-z0-9.+-]{1,31}:[^<>\\x00-\\x20]*>", options: [.caseInsensitive])

    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let email = input.parse(Self.emailAutolinkRegex)
        if email.value.isNotEmpty {
            let mailtoText = email.value.trimmed(by: 1)
            let mailtoTextRangeStart = email.valueLocation.advance()
            let mailtoTextRangeEnd = email.remaining.retreat().retreat()
            let mailToTextRange = TextRange(start: mailtoTextRangeStart, end: mailtoTextRangeEnd)
            let mailto = "mailto:\(mailtoText)"
            return email.map { _ in
                .link(InlineLink(link: Link(title: nil, url: InlineString(text: mailto, range: mailToTextRange)),
                                 text: [.text(InlineString(text: String(mailtoText), range: mailToTextRange))],
                                 range: email.valueTextRange))
            }
        }
        
        let autolink = input.parse(Self.autolinkRegex)
        if autolink.value.isNotEmpty {
            let autolinkText = String(autolink.value.trimmed(by: 1))
            let autolinkTextRangeStart = autolink.valueLocation.advance()
            let autolinkTextRangeEnd = autolink.remaining.retreat().retreat()
            let autolinkTextRange = TextRange(start: autolinkTextRangeStart, end: autolinkTextRangeEnd)

            return autolink.map { _ in
                .link(InlineLink(link: Link(title: nil, url: InlineString(text: autolinkText, range: autolinkTextRange)),
                                 text: [.text(InlineString(text: autolinkText, range: autolinkTextRange))],
                                 range: autolink.valueTextRange))
            }
        }
        
        return input.noMatch(nil)
    }
}
