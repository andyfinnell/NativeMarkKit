import Foundation


struct ItemBlockStarter: BlockStarter {
    private static let startBulletedRegex = try! NSRegularExpression(pattern: "^[*+-]", options: [])
    private static let startOrderedRegex = try! NSRegularExpression(pattern: "^(\\d{1,9})([.)])", options: [])
    private struct ItemMarker {
        let markerIndent: LineColumnCount
        let padding: LineColumnCount
        let kind: ListKind
    }

    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        guard let itemMarkerResult = parseMarker(line, in: container) else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        closer.close()
        
        var list = container
        if !isSameKindOfList(container, as: itemMarkerResult.value.kind) {
            let listStyle = ListStyle(isTight: true, kind: itemMarkerResult.value.kind)
            list = Block(kind: .list(listStyle), parser: ListBlockParser())
            _ = container.addChild(list)
        }
        
        let parser = ItemBlockParser(markerOffset: itemMarkerResult.value.markerIndent,
                                     padding: itemMarkerResult.value.padding)
        let itemBlock = Block(kind: .item, parser: parser)
        _ = list.addChild(itemBlock)
        
        return LineResult(remainingLine: itemMarkerResult.remainingLine, value: .container(itemBlock))
    }
}

private extension ItemBlockStarter {
    func isSameKindOfList(_ container: Block, as listKind: ListKind) -> Bool {
        guard case let .list(existingListStyle) = container.kind else {
            return false
        }
        return existingListStyle.kind.isSameKind(listKind)
    }
    
    func isMarkerMatchValid(_ match: NSTextCheckingResult, on line: Line, in container: Block) -> Bool {
        let remainingLine = line.replace(match, with: "")
        // next character after match needs to space or tab or end-of-line
        let isTabOrSpaceOrEol = remainingLine.text.first?.isSpaceOrTab ?? true
        if !isTabOrSpaceOrEol {
            return false
        }
        
        // if interrupting paragraph, first line cant' be blank
        if container.kind == .paragraph && remainingLine.isBlank {
            return false
        }
        
        return true
    }
    
    func parsePostMarkerPadding(_ match: NSTextCheckingResult, on line: Line) -> LineResult<LineColumnCount> {
        let remainingLine = line.replace(match, with: "")

        let indentedLine = remainingLine.trimIndent(LineColumnCount(5))
        let isBlankItem = indentedLine.isBlank
        let spacesAfterMarker = indentedLine.startColumn - remainingLine.startColumn
        if spacesAfterMarker >= LineColumnCount(5) || spacesAfterMarker < LineColumnCount(1) || isBlankItem {
            // Assume just one space
            let padding = LineColumnCount(line.text.matchedText(match).count + 1)
            let finalLine = remainingLine.trimIndent(LineColumnCount(1))
            
            return LineResult(remainingLine: finalLine, value: padding)
        } else {
            let padding = LineColumnCount(line.text.matchedText(match).count) + spacesAfterMarker
            return LineResult(remainingLine: indentedLine, value: padding)
        }
    }
    
    private func parseMarker(_ line: Line, in container: Block) -> LineResult<ItemMarker>? {
        let markerIndent = line.indent
        guard markerIndent < LineColumnCount(4) else {
            return nil
        }
        let realLine = line.trimIndent(markerIndent)
        
        if let match = realLine.firstMatch(Self.startBulletedRegex),
            isMarkerMatchValid(match, on: realLine, in: container) {
            let bulletChar = realLine.text.matchedText(match)
            let paddingResult = parsePostMarkerPadding(match, on: realLine)
            let itemMarker = ItemMarker(markerIndent: markerIndent,
                                        padding: paddingResult.value,
                                        kind: .bulleted(bulletChar))
            return LineResult(remainingLine: paddingResult.remainingLine,
                              value: itemMarker)
        } else if let match = realLine.firstMatch(Self.startOrderedRegex),
                let startNumber = Int(realLine.text.matchedText(match, at: 1)),
                (container.kind != .paragraph || startNumber == 1)
                && isMarkerMatchValid(match, on: realLine, in: container) {
            let delimiter = realLine.text.matchedText(match, at: 2)
            let paddingResult = parsePostMarkerPadding(match, on: realLine)
            let itemMarker = ItemMarker(markerIndent: markerIndent,
                                        padding: paddingResult.value,
                                        kind: .ordered(start: startNumber, delimiter: delimiter))
            return LineResult(remainingLine: paddingResult.remainingLine,
                              value: itemMarker)
        } else {
            return nil
        }
    }
}
