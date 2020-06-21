import Foundation

struct OpenBracketParser {
    func parse(_ input: TextCursor) -> TextResult<Delimiter?> {
        let bracket = input.parse("[")
        guard bracket.value.isNotEmpty else {
            return input.noMatch(nil)
        }

        return bracket.map {
            Delimiter(character: "[",
                      count: 1,
                      canOpen: true,
                      canClose: false,
                      inlineText: .text($0),
                      startCursor: input)
        }
    }
}
