import Foundation

struct LineParser {
    private let continutationParser = BlockContinuationParser()
    private let startParser = BlockStartParser()
    private let treeInserter = BlockTreeInserter()
    
    func parse(_ lines: AnySequence<Line>, into root: Block) {
        for line in lines {
            parse(line, into: root)
        }
    }
}

private extension LineParser {
    func parse(_ line: Line, into root: Block) {
        let continuation = continutationParser.parse(line, for: root)
        let startOps = startParser.parse(continuation.remainingLine)
        let didAddBlock = treeInserter.insert(startOps, on: continuation.value.openBlock)
        
        if didAddBlock || line.isBlank {
            closeUnmatchedBlocks(continuation.value.unmatchedBlocks)
        }
    }

    func closeUnmatchedBlocks(_ unmatchedBlocks: [Block]) {
        for block in unmatchedBlocks {
            block.isOpen = false
        }
    }
}
