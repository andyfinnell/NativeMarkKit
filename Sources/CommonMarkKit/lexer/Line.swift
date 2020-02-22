import Foundation

struct Line {
    let range: CursorRange<Source>
}

extension Line {
    var isBlank: Bool {
        let blankCharacters = Set<Character>([" ", "\t", "\n"])
        return !range.sequence.contains(where: { !blankCharacters.contains($0) })
    }
}
