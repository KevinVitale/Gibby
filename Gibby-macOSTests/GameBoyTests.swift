import XCTest
@testable import Gibby

final class GameBoySystemTests: XCTestCase {
    var systems: [GameBoy] { return [.original, .color, .advance] }
    
    func testLogoCount() {
        for system in systems {
            switch system {
            case .original: fallthrough
            case    .color: XCTAssertEqual(system.logo.count, 48)
            case  .advance: XCTAssertEqual(system.logo.count, 156)
            }
        }
    }
    
    func testHeaderSize() {
        for system in systems {
            switch system {
            case .original: fallthrough
            case    .color: XCTAssertEqual(system.headerSize, 80)
            case  .advance: XCTAssertEqual(system.headerSize, 192)
            }
        }
    }
    
    func testHeaderOffset() {
        for system in systems {
            switch system {
            case .original: fallthrough
            case    .color: XCTAssertEqual(system.headerOffset, 256)
            case  .advance: XCTAssertEqual(system.headerOffset, 134217728)
            }
        }
    }
}
