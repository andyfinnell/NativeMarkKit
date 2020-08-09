import Foundation

final class OrderedListMarkerFormatValue: NSObject {
    let format: OrderedListMarkerFormat
    let prefix: String
    let suffix: String
    
    init(format: OrderedListMarkerFormat, prefix: String, suffix: String) {
        self.format = format
        self.prefix = prefix
        self.suffix = suffix
        super.init()
    }
    
    func render(_ number: Int) -> String {
        format.render(number, prefix: prefix, suffix: suffix)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? OrderedListMarkerFormatValue else {
            return false
        }
        
        return format == rhs.format && prefix == rhs.prefix && suffix == rhs.suffix
    }
}
