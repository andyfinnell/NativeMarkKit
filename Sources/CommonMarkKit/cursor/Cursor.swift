import Foundation

struct Cursor<S: CursorSource> {
    let source: S
    let index: S.SourceIndex
    private let filters: List<AnyCursorFilter<S.Element>>
        
    init(source: S, index: S.SourceIndex) {
        self.source = source
        self.index = index
        self.filters = .unit
    }
    
    var element: CursorElement<S> {
        guard index < source.endIndex else {
            return .eof
        }
        
        let value = source[index]
        let cursorValue = CursorValue(value: value, location: self)
        return .value(cursorValue)
    }
    
    func advance() -> Cursor<S> {
        return advanceOnce().advanceIfExcluded()
    }
    
    func regress() -> Cursor<S> {
        var cursor = regressOnce()
        while cursor.isExcluded() && cursor.index != source.startIndex {
            cursor = cursor.regressOnce()
        }
        if cursor.isExcluded() && cursor.index == source.startIndex {
            cursor = cursor.advance()
        }
        return cursor
    }
    
    func mode(_ filter: AnyCursorFilter<S.Element>, block: (Cursor<S>) throws -> Cursor<S>) rethrows -> Cursor<S> {
        return try block(pushFilter(filter).advanceIfExcluded()).popFilter()
    }
}

extension Cursor: Comparable {
    static func < (lhs: Cursor, rhs: Cursor) -> Bool {
        return lhs.index < rhs.index
    }
    
    static func ==(lhs: Cursor, rhs: Cursor) -> Bool {
        return lhs.index == rhs.index
    }
}

extension Cursor {
    var isStart: Bool {
        return index == source.startIndex
    }
    
    var notStart: Bool {
        return index != source.startIndex
    }
    
    var isEnd: Bool {
        return element == .eof
    }
    
    var notEnd: Bool {
        return element != .eof
    }
}

private extension Cursor {
    init(source: S, index: S.SourceIndex, filters: List<AnyCursorFilter<S.Element>>) {
        self.source = source
        self.index = index
        self.filters = filters
    }

    func pushFilter(_ filter: AnyCursorFilter<S.Element>) -> Cursor<S> {
        return Cursor(source: source,
                      index: index,
                      filters: filters.push(filter))
    }
    
    func popFilter() -> Cursor<S> {
        return Cursor(source: source,
                      index: index,
                      filters: filters.pop())
    }
    
    func update(index: S.SourceIndex) -> Cursor<S> {
        return Cursor(source: source,
                      index: index,
                      filters: filters)
    }

    func isExcluded() -> Bool {
        guard case let .value(value) = element else {
            return false // always include eof so we stop
        }
        return filters.contains(where: { !$0.isIncluded(value.value) })
    }
    
    func advanceOnce() -> Cursor<S> {
        guard index < source.endIndex else {
            return update(index: source.endIndex)
        }

        let nextIndex = source.index(after: index)
        return update(index: nextIndex)
    }
    
    func advanceIfExcluded() -> Cursor<S> {
        var cursor = self
        while cursor.isExcluded() {
            cursor = cursor.advanceOnce()
        }
        return cursor
    }
    
    func regressOnce() -> Cursor<S> {
        guard index > source.startIndex else {
            return update(index: source.startIndex)
        }
        
        let priorIndex = source.index(before: index)
        return update(index: priorIndex)
    }

}
