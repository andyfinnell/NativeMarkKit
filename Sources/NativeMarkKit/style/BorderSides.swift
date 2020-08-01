import Foundation

public struct BorderSides: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let left = BorderSides(rawValue: 1 << 0)
    public static let right = BorderSides(rawValue: 1 << 1)
    public static let top = BorderSides(rawValue: 1 << 2)
    public static let bottom = BorderSides(rawValue: 1 << 3)
    
    public static let all: BorderSides = [.left, .right, .top, .bottom]
}
