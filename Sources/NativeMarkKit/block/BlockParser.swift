import Foundation

protocol BlockParser {
    var acceptsLines: Bool { get }
    
    func acceptsChild(_ block: Block) -> Bool
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool>

    func close(_ block: Block)
    
    func isThisLineBlankForPurposesOfLastLine(_ line: Line, block: Block) -> Bool
    var doesPreventChildrenFromHavingLastLineBlank: Bool { get }
    
    func parseLinkDefinitions(_ block: Block) -> Bool
}
