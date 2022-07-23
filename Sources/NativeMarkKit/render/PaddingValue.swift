import Foundation

final class PaddingValue: NSObject {
    let padding: PointPadding
    
    init(padding: PointPadding) {
        self.padding = padding
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? PaddingValue else {
            return false
        }
        return padding == other.padding
    }
}
