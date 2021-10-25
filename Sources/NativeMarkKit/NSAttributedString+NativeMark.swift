import Foundation

extension NSAttributedString {
    convenience init(nativeMark: String, styleSheet: StyleSheet) throws {
        let document = try NativeMark.compile(nativeMark)
        let renderer = Renderer()
        self.init(attributedString: renderer.render(document, with: styleSheet))
    }
}
