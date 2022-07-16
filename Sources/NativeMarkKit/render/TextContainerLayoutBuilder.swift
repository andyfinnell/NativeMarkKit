import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class TextContainerLayoutBuilder {
    private var containerBreaks: [ContainerBreakValue]
    private var nextTextContainerToUse = 0
    private let layoutManager: LayoutManager
    
    init(storage: NSTextStorage, layoutManager: LayoutManager) {
        self.layoutManager = layoutManager
        self.containerBreaks = storage.containerBreaks()
    }
    
    func nextContainerBreak() -> ContainerBreakValue? {
        containerBreaks.first
    }
    
    func removeNextContainerBreak() {
        containerBreaks.removeFirst()
    }
    
    func makeTextContainer() -> TextContainer {
        if let textContainer = layoutManager.textContainers.at(nextTextContainerToUse) as? TextContainer {
            textContainer.origin = .zero
            nextTextContainerToUse += 1 // nice, reuse
            return textContainer
        } else {
            let textContainer = TextContainer()
            layoutManager.addTextContainer(textContainer)
            nextTextContainerToUse += 1 // can't use this one, so skip it
            return textContainer
        }
    }
    
    func removeUnusedTextContainers() {
        while layoutManager.textContainers.count > nextTextContainerToUse {
            layoutManager.removeTextContainer(at: layoutManager.textContainers.count - 1)
        }
    }
}
