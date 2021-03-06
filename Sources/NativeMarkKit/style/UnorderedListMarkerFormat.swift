import Foundation

public enum UnorderedListMarkerFormat: Equatable {
    case bullet
    case box
    case check
    case circle
    case diamond
    case hyphen
    case square
    case custom(NSAttributedString)
}
