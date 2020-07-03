import Foundation

struct FencedCodeBlockParser: BlockParser {
    private static let endingRegex = try! NSRegularExpression(pattern: "^(?:`{3,}|~{3,})(?= *$)", options: [])
    private let fence: String
    private let fenceOffset: LineColumnCount
    
    init(fenceOffset: LineColumnCount, fence: String) {
        self.fenceOffset = fenceOffset
        self.fence = fence
    }
    
    let acceptsLines = true
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        if isEndingFence(line.nonIndentedStart) {
            block.close()
            
            return LineResult(remainingLine: .blank, value: true)
        } else {
            let remainingLine = line.trimIndent(fenceOffset)
            return LineResult(remainingLine: remainingLine, value: true)
        }
    }

    func close(_ block: Block) {
        let infoString = block.removeFirstLine().text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .unescaped()
        block.kind = .codeBlock(infoString: infoString)
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        false
    }
    
    func parseLinkDefinitions(_ block: Block) -> Bool {
        // nop
        false
    }
}

private extension FencedCodeBlockParser {
    func isEndingFence(_ line: Line) -> Bool {
        guard let endingMatch = line.firstMatch(Self.endingRegex) else {
            return false
        }
        return line.text.matchedText(endingMatch).count >= fence.count
            && line.hasPrefix(fence)
    }
}
