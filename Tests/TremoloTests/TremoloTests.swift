import XCTest
@testable import Tremolo

final class TremoloTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Tremolo().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
