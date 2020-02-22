import Foundation

protocol CursorFilter {
    associatedtype Element: Equatable
    
    func isIncluded(_ element: Element) -> Bool
}

struct AnyCursorFilter<Element: Equatable>: CursorFilter {
    private let isIncludedThunk: (Element) -> Bool
    
    init<F: CursorFilter>(_ filter: F) where F.Element == Element {
        self.isIncludedThunk = { filter.isIncluded($0) }
    }
    
    func isIncluded(_ element: Element) -> Bool {
        return isIncludedThunk(element)
    }
}
