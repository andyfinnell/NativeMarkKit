import Foundation

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
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? OrderedListMarkerFormatValue else {
            return false
        }
        
        return format == rhs.format && separator == rhs.separator
    }
}
