import Foundation

final class TextContainerLayoutBuilder {
    private var containerBreaks: [ContainerBreakValue]
    private var nextTextContainerToUse = 0
    private let layoutManager: NativeMarkLayoutManager
    
    init(storage: NativeMarkStorage, layoutManager: NativeMarkLayoutManager) {
        self.layoutManager = layoutManager
        self.containerBreaks = storage.containerBreaks()
    }
    
    func nextContainerBreak() -> ContainerBreakValue? {
        containerBreaks.first
    }
    
    func removeNextContainerBreak() {
        containerBreaks.removeFirst()
    }
    
    func makeTextContainer() -> NativeMarkTextContainer {
        if let textContainer = layoutManager.textContainers.at(nextTextContainerToUse) {
            textContainer.container.origin = .zero
            nextTextContainerToUse += 1 // nice, reuse
            return textContainer
        } else {
            let textContainer = NativeMarkTextContainer()
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
