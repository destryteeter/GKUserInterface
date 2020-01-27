import XCTest
@testable import GKUserInterface

final class GKUserInterfaceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GKUI.version, "1.0")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
