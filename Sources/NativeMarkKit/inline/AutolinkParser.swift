import Foundation

struct AutolinkParser {
    private static let emailAutolinkRegex = try! NSRegularExpression(pattern: "^<([a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>", options: [])
    private static let autolinkRegex = try! NSRegularExpression(pattern: "^<[A-Za-z][A-Za-z0-9.+-]{1,31}:[^<>\\x00-\\x20]*>", options: [.caseInsensitive])

    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let email = input.parse(Self.emailAutolinkRegex)
        if email.value.isNotEmpty {
            let mailtoText = email.value.trimmed(by: 1)
            let mailto = "mailto:\(mailtoText)"
            return email.map { _ in .link(Link(title: "", url: mailto), text: [.text(mailtoText)]) }
        }
        
        let autolink = input.parse(Self.autolinkRegex)
        if autolink.value.isNotEmpty {
            let autolinkText = autolink.value.trimmed(by: 1)
            return autolink.map { _ in .link(Link(title: "", url: autolinkText), text: [.text(autolinkText)]) }
        }
        
        return input.noMatch(nil)
    }
}
