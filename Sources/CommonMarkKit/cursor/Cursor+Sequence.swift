import Foundation

extension Cursor {
    func sequence(ofLength length: Int) -> AnySequence<S.Element> {
        return AnySequence<S.Element> { () -> AnyIterator<S.Element> in
            var count = 0
            var current = self
            return AnyIterator<S.Element> { () -> S.Element? in
                guard case let .value(value) = current.element, count < length else {
                    return nil
                }
                count += 1
                current = current.advance()
                return value.value
            }
        }
    }
    
    func sequence(upTo endCursor: Cursor) -> AnySequence<S.Element> {
        return AnySequence<S.Element> { () -> AnyIterator<S.Element> in
            var current = self
            return AnyIterator<S.Element> { () -> S.Element? in
                guard case let .value(value) = current.element, current < endCursor else {
                    return nil
                }
                current = current.advance()
                return value.value
            }
        }
    }

}
