import XCTest
import Gibby

class GameBoyTests: XCTestCase {
    func testOriginal() {
        XCTAssertEqual(GameBoy.original.logo.count, 48)
    }

    func testColor() {
        XCTAssertEqual(GameBoy.color.logo.count, 48)
    }

    func testAdvance() {
        XCTAssertEqual(GameBoy.advance.logo.count, 156)
    }
}
