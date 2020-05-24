import Foundation

struct LineParser {
    private let continutationParser = BlockContinuationParser()
    private let startParser = BlockStartParser()
    private let lineInserter = LineInserter()
    
    func parse(_ lines: AnySequence<Line>, into root: Block) {
        let tip = lines.reduce(root) { tip, line in
            parse(line, into: root, tip: tip)
        }
        close(tip)
    }
}

private extension LineParser {
    func parse(_ line: Line, into root: Block, tip: Block) -> Block {
        let continuation = continutationParser.parse(line, for: root)
        let closeParser = BlockCloser(blocks: continuation.value.unmatchedBlocks)
        let startMatch = startParser.parse(continuation.remainingLine, for: continuation.value.openBlock, using: closeParser)
        
        return lineInserter.insert(startMatch.remainingLine,
                                   into: startMatch.value.tip,
                                   tip: tip,
                                   closer: closeParser)
    }
    
    func close(_ tip: Block) {
        var current: Block? = tip
        while let block = current {
            block.close()
            current = block.parent
        }
    }
}
