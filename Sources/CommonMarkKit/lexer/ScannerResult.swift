import Foundation

struct ScannerResult<T> {
    let remaining: Cursor<Source>
    let value: T
}
