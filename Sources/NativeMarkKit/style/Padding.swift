import Foundation

public struct Padding {
    public let left: Length
    public let right: Length
    public let top: Length
    public let bottom: Length
    
    public init(left: Length = 0.pt,
                right: Length = 0.pt,
                top: Length = 0.pt,
                bottom: Length = 0.pt) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}

