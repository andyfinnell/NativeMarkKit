import Foundation

struct Identifier<Phantom>: Hashable {
    private let value: UUID
    
    init() {
        self.value = UUID()
    }
}
