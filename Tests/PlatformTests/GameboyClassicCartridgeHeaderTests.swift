import XCTest
@testable import Gibby

class GameboyClassicHeaderSectionTests: XCTestCase {
    typealias HeaderSection = GameboyClassic.HeaderSection
    
    func testSections() {
        let sections = (0x00..<0x50).compactMap { HeaderSection(rawValue: $0) }
        XCTAssertEqual(sections.count, HeaderSection.allSections.count)
    }
    
    func testRanges() {
        for section in HeaderSection.allSections {
            switch section {
            case .boot:
                XCTAssertEqual(section.range().count, 4)
                XCTAssertEqual(section.range().upperBound, 0x04)
            case .logo:
                XCTAssertEqual(section.range().count, 48)
                XCTAssertEqual(section.range().upperBound, 0x34)
            case .title:
                XCTAssertEqual(section.range().count, 16)
                XCTAssertEqual(section.range().upperBound, 0x44)
            case .manufacturer:
                XCTAssertEqual(section.range().count, 4)
                XCTAssertEqual(section.range().upperBound, 0x43)
            case .colorFlag:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x44)
            case .licensee:
                XCTAssertEqual(section.range().count, 2)
                XCTAssertEqual(section.range().upperBound, 0x46)
            case .superGameboyFlag:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x47)
            case .memoryController:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x48)
            case .romSize:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x49)
            case .ramSize:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x4A)
            case .region:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x4B)
            case .legacyLicensee:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x4C)
            case .versionMask:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x4D)
            case .headerChecksum:
                XCTAssertEqual(section.range().count, 1)
                XCTAssertEqual(section.range().upperBound, 0x4E)
            case .cartChecksum:
                XCTAssertEqual(section.range().count, 2)
                XCTAssertEqual(section.range().upperBound, 0x50)
            }
        }
    }
    
    func testSectionBoot() {
        // var header = Header(bytes: Data([0x00, 0xC3, 0x50, 0x01]))
    }
}
