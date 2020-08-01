import Foundation

extension NSAttributedString.Key {
    static let leadingMarginIndent = NSAttributedString.Key("nativeMarkKit.leadingMarginIndent")
    static let orderedListMarkerFormat = NSAttributedString.Key("nativeMarkKit.orderedListMarkerFormat")
    static let unorderedListMarkerFormat = NSAttributedString.Key("nativeMarkKit.unorderedListMarkerFormat")
    static let thematicBreakThickness = NSAttributedString.Key("nativeMarkKit.thematicBreakThickness")
    static let thematicBreakColor = NSAttributedString.Key("nativeMarkKit.thematicBreakColor")
}

final class OrderedListMarkerFormatValue: NSObject {
    let format: OrderedListMarkerFormat
    let separator: String
    
    init(format: OrderedListMarkerFormat, separator: String) {
        self.format = format
        self.separator = separator
        super.init()
    }
    
    func render(_ number: Int) -> String {
        format.render(number, separator: separator)
    }
}

final class UnorderedListMarkerFormatValue: NSObject {
    let format: UnorderedListMarkerFormat
    
    init(format: UnorderedListMarkerFormat) {
        self.format = format
        super.init()
    }
    
    func render() -> NSAttributedString {
        format.render()
    }
}
