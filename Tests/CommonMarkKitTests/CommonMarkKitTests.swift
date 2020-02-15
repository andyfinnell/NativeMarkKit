import XCTest
@testable import CommonMarkKit

final class CommonMarkKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CommonMarkKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
