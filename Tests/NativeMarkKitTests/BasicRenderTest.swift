import Foundation
import XCTest

final class BasicRenderTest: XCTestCase {
    func testHelloWorld() {
        let testCase = RenderTestCase(name: "HelloWorld",
                                      nativeMark: "**Hello**, _world_!",
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
}
