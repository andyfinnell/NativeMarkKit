import Foundation

extension Array {
    func at(_ index: Index) -> Element? {
        guard index >= startIndex && index < endIndex else {
            return nil
        }
        return self[index]
    }
}
