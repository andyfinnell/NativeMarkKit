import Foundation

struct BlockLinkDefinition {
    let key: LinkLabel
    let label: InlineString
    let link: Link
    let range: TextRange?
    
    init(label: InlineString, url: InlineString, title: InlineString?, range: TextRange?) {
        self.key = LinkLabel(label)
        self.label = label
        self.link = Link(title: title, url: url)
        self.range = range
    }
}
