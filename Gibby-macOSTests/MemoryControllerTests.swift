import XCTest
@testable import Gibby

class MemomryControllerTests: XCTestCase {
    func testROMOnly() {
        let romOnly = MemoryController(rawValue: 0)!
        XCTAssertEqual(romOnly, .rom(ram: false, battery: false))
    }
}
