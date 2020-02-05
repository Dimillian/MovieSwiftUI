import XCTest
@testable import Backend

final class BackendTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Backend().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
