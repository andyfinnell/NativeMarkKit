import Foundation

protocol BlockParser {
    var acceptsLines: Bool { get }
    
    func acceptsChild(_ block: Block) -> Bool
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool>

    func close(_ block: Block)
    
    func canHaveLastLineBlank(_ block: Block) -> Bool
    
    func parseLinkDefinitions(_ block: Block) -> Bool
}
