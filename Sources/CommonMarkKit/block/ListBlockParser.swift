import Foundation

struct ListBlockParser: BlockParser {
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        block.kind == .item
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        LineResult(remainingLine: line, value: true)
    }

    func close(_ block: Block) {
        guard case let .list(listStyle) = block.kind else {
            return
        }
        
        let isTight = !isListLoose(block)
        block.kind = .list(listStyle.update(isTight: isTight))
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        true
    }
}

private extension ListBlockParser {
    func isListLoose(_ block: Block) -> Bool {
        block.children.reduce(false) { isLoose, block in
            isLoose || self.isLoose(block)
        }
    }
    
    func isLoose(_ item: Block) -> Bool {
        if hasSpaceBetweenItems(item) {
            return true
        }
        
        return item.children.reduce(false) { isLoose, subitem in
            isLoose || hasSpaceBetweenItems(subitem, isParentLastChild: item.isLastChild)
        }
    }
    
    func hasSpaceBetweenItems(_ item: Block) -> Bool {
        endsInBlankLine(item) && !item.isLastChild
    }

    func hasSpaceBetweenItems(_ item: Block, isParentLastChild: Bool) -> Bool {
        endsInBlankLine(item) && (!item.isLastChild || !isParentLastChild)
    }
    
    func endsInBlankLine(_ block: Block) -> Bool {
        var next: Block? = block
        while let current = next {
            if current.isLastLineBlank {
                return true
            }
            
            switch current.kind {
            case .list,
                 .item:
                next = current.children.last
            default:
                next = nil // stop
            }
        }
        return false
    }
}
