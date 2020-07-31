import Foundation

extension UnorderedListMarkerFormat {
    func render() -> NSAttributedString {
        switch self {
        case .box:
            return NSAttributedString(string: "\u{2610}")
        case .bullet:
            return NSAttributedString(string: "\u{2022}")
        case .check:
            return NSAttributedString(string: "\u{2713}")
        case .circle:
            return NSAttributedString(string: "\u{25EF}")
        case let .custom(value):
            return value
        case .diamond:
            return NSAttributedString(string: "\u{25C6}")
        case .hyphen:
            return NSAttributedString(string: "\u{2043}")
        case .square:
            return NSAttributedString(string: "\u{25FE}")
        }
    }
}
