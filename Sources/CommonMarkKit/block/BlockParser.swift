import Foundation

protocol BlockParser {
    var acceptsLines: Bool { get }
    
    func acceptsChild(_ block: Block) -> Bool
    
    func attemptContinuation(with line: Line) -> LineResult<Bool>

    func close()
}
