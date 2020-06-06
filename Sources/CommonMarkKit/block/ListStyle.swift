import Foundation

struct ListStyle: Equatable {
    let isTight: Bool
    let kind: ListKind
}

extension ListStyle {
    func update(isTight: Bool) -> ListStyle {
        ListStyle(isTight: isTight, kind: kind)
    }
}
