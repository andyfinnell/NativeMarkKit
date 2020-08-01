import Foundation

final class UnorderedListMarkerFormatValue: NSObject {
    let format: UnorderedListMarkerFormat
    
    init(format: UnorderedListMarkerFormat) {
        self.format = format
        super.init()
    }
    
    func render() -> NSAttributedString {
        format.render()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? UnorderedListMarkerFormatValue else {
            return false
        }
        return format == rhs.format
    }
}

