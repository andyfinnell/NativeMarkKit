import Foundation

struct ParagraphBlockParser: BlockParser {
    let acceptsLines = true
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        if line.isBlank {
            return LineResult(remainingLine: line, value: false)
        } else {
            return LineResult(remainingLine: line, value: true)
        }
    }

    func close(_ block: Block) {
        parseLinkDefinitions(block)
        
        if !block.hasText && !block.linkDefinitions.isEmpty {
            block.removeFromParent()
        }
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        true
    }
    
    func parseLinkDefinitions(_ block: Block) {
        let parser = LinkDefinitionsLineParser()
        var definitions = [LinkDefinition]()
        block.updateText { lines in
            let result = parser.parse(lines)
            definitions = result.0
            return result.1
        }
        block.addLinkDefinitions(definitions)
    }
}
