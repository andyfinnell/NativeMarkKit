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
        let hadDefinitions = parseLinkDefinitions(block)
        
        if !block.hasText && hadDefinitions {
            block.removeFromParent()
        }
    }
    
    func isThisLineBlankForPurposesOfLastLine(_ line: Line, block: Block) -> Bool {
        line.isBlank
    }
    
    let doesPreventChildrenFromHavingLastLineBlank = false

    func parseLinkDefinitions(_ block: Block) -> Bool {
        let parser = LinkDefinitionsLineParser()
        var definitions = [LinkDefinition]()
        block.updateText { lines in
            let result = parser.parse(lines)
            definitions = result.0
            return result.1
        }
        block.addLinkDefinitions(definitions)
        return !definitions.isEmpty
    }
}
