import Foundation

final class BorderValue: NSObject {
    let border: Border
    
    init(border: Border) {
        self.border = border
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? BorderValue else {
            return false
        }
        return border == other.border
    }
}
