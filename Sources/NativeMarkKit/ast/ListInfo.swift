import Foundation

struct ListInfo: Equatable {
    let isTight: Bool
    let kind: ListInfoKind
}

extension ListInfo: CustomStringConvertible {
    var description: String {
        let tightOrLoose = isTight ? "tight" : "loose"
        return "linfo { \(tightOrLoose) \(kind) }"
    }
}
