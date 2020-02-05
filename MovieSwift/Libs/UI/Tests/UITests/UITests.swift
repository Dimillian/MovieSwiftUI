import XCTest
@testable import UI

final class UITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
