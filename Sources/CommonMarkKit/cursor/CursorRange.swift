import Foundation

struct CursorRange<S: CursorSource>: Equatable {
    let start: Cursor<S>
    let end: Cursor<S> // exclusive; points to next item after last valid item in range
}

extension CursorRange {
    var source: S {
        return start.source
    }
    
    var sequence: AnySequence<S.Element> {
        return start.sequence(upTo: end)
    }
}

extension CursorRange: CursorSource {
    typealias SourceIndex = S.SourceIndex
    typealias Element = S.Element
    
    var filename: String {
        return source.filename
    }
    
    var startIndex: SourceIndex {
        return start.index
    }
    
    var endIndex: SourceIndex {
        return end.index
    }
    
    func index(after index: SourceIndex) -> SourceIndex {
        guard index < endIndex else {
            return endIndex
        }
        return start.source.index(after: index)
    }
    
    func index(before index: SourceIndex) -> SourceIndex {
        guard index > startIndex else {
            return startIndex
        }
        return start.source.index(before: index)
    }
    
    subscript(index: SourceIndex) -> S.Element {
        return start.source[index]
    }
}
