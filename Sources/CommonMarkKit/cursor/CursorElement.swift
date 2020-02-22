import Foundation

struct CursorValue<S: CursorSource>: Equatable {
    let value: S.Element
    let location: Cursor<S>
}

enum CursorElement<S: CursorSource>: Equatable {
    case value(CursorValue<S>)
    case eof
}
