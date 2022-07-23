import Foundation

final class MarginValue: NSObject {
    let margin: PointMargin
    
    init(margin: PointMargin) {
        self.margin = margin
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? MarginValue else {
            return false
        }
        return margin == other.margin
    }
}
