import Foundation

struct EntityParser {
    private static let entityRegex = try! NSRegularExpression(pattern: "^\(String.entityPattern)", options: [.caseInsensitive])
    
    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let entity = input.parse(Self.entityRegex)
        guard entity.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        return entity.map { .text(InlineString(text: $0.unescaped(), range: entity.valueTextRange)) }
    }
}
