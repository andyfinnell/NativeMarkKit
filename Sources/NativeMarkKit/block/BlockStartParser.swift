import Foundation

enum BlockStartMatch {
    case container(Block)
    case leaf(Block)
    case none
}

protocol BlockStarter {
    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch>
}

struct BlockStart {
    let tip: Block
}

final class BlockStartParser {
    private let starters: [BlockStarter] = [
        BlockQuoteStarter(),
        ATXHeadingBlockStarter(),
        FencedCodeBlockStarter(),
        SetextHeadingBlockStarter(),
        ThematicBreakBlockStarter(),
        ItemBlockStarter(),
        IndentedCodeBlockStarter()
    ]
    
    init() {
        
    }
    
    func parse(_ line: Line, root: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStart> {
        var container = root
        var remainingLine = line
        var isLeaf = root.acceptsLines && root.kind != .paragraph
        while !remainingLine.isBlank && !isLeaf {
            let start = parseLine(remainingLine, in: container, tip: tip, using: closer)
            switch start.value {
            case let .container(block):
                container = block
            case let .leaf(block):
                container = block
                isLeaf = true
            case .none:
                return LineResult(remainingLine: start.remainingLine, value: BlockStart(tip: container))
            }
            remainingLine = start.remainingLine
        }
        return LineResult(remainingLine: remainingLine, value: BlockStart(tip: container))
    }
}

private extension BlockStartParser {
    func parseLine(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        for parser in starters {
            let start = parser.parseStart(line, in: container, tip: tip, using: closer)
            if case .none = start.value {
                continue
            } else {
                return start
            }
        }

        return LineResult(remainingLine: line, value: .none)
    }
}
