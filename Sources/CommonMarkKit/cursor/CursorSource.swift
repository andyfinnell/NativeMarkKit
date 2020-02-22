import Foundation

protocol CursorSource {
    associatedtype SourceIndex: Comparable
    associatedtype Element: Equatable
    
    var filename: String { get }
    
    var startIndex: SourceIndex { get }
    var endIndex: SourceIndex { get } // exclusive. index does not point to valid data
    
    func index(after index: SourceIndex) -> SourceIndex
    func index(before index: SourceIndex) -> SourceIndex
    
    subscript(_ index: SourceIndex) -> Element { get }
}
