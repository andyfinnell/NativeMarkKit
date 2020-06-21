import Foundation

struct LinkDefinition {
    let key: LinkLabel
    let link: Link
    
    init(label: String, url: URL, title: String) {
        self.key = LinkLabel(label)
        self.link = Link(title: title, url: url)
    }
}
