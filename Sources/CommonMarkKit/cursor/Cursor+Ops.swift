import Foundation

func ==<S: CursorSource>(lhs: Cursor<S>, rhs: S.Element) -> Bool {
    guard case .value(let v) = lhs.element else {
        return false
    }
    return v.value == rhs
}

func !=<S: CursorSource>(lhs: Cursor<S>, rhs: S.Element) -> Bool {
    guard case .value(let v) = lhs.element else {
        return true
    }
    return v.value != rhs
}

func ~=<S: CursorSource>(lhs: S.Element, rhs: Cursor<S>) -> Bool {
    guard case .value(let v) = rhs.element else {
        return false
    }
    return v.value == lhs
}
