import Foundation

struct BangParser {
    func parse(_ input: TextCursor) -> TextResult<DelimiterOrInlineText?> {
        let bangBracket = input.parse("![")
        if bangBracket.value.isNotEmpty {
            return bangBracket.map {
                .delimiter(Delimiter(character: $0,
                                     count: 1,
                                     canOpen: true,
                                     canClose: false,
                                     startCursor: input))
            }
        }
        
        let bang = input.parse("!")
        guard bang.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        return bang.map { .inlineText(.text($0)) }
    }
}
