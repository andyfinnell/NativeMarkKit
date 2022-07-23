import Foundation

enum ContainerKind: Equatable {
    case leaf // paragraph, thematicBreak, heading, codeBlock
    case blockQuote(TextContainerStyle)
    case list(ListValue)
    case listItem
    case listItemMarker
    case listItemContent
    case codeBlock(TextContainerStyle)
    
    static func==(lhs: ContainerKind, rhs: ContainerKind) -> Bool {
        switch (lhs, rhs) {
        case (.leaf, .leaf):
            return true
        case (.blockQuote, .blockQuote):
            return true
        case (.list, .list):
            return true
        case (.listItem, .listItem):
            return true
        case (.listItemMarker, .listItemMarker):
            return true
        case (.listItemContent, .listItemContent):
            return true
        case (.codeBlock, .codeBlock):
            return true
        default:
            return false
        }
    }
}

extension ContainerKind: CustomStringConvertible {
    var description: String {
        switch self {
        case .leaf: return "leaf"
        case .blockQuote: return "blockQuote"
        case .list: return "list"
        case .listItem: return "listItem"
        case .listItemMarker: return "itemMarker"
        case .listItemContent: return "itemContent"
        case .codeBlock: return "codeBlock"
        }
    }
}

final class ContainerBreakValue: NSObject {
    let path: [ContainerKind]
    let shouldContainerBreak: Bool
    
    init(path: [ContainerKind], shouldContainerBreak: Bool) {
        self.path = path
        self.shouldContainerBreak = shouldContainerBreak
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ContainerBreakValue else {
            return false
        }
        return path == other.path && shouldContainerBreak == other.shouldContainerBreak
    }
}
