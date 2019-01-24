import XCTest
import Gibby

class MemomryControllerTests: XCTestCase {
    func testAllValues() {
        XCTAssertEqual(MemoryController.allControllers.count, 28)
    }
    
    func testConfigurations() {
        let expectedFulfillmentCount = MemoryController.allControllers.count
        let configsTested = XCTestExpectation(description: "Only \(expectedFulfillmentCount) configurations should be valid.")
        configsTested.expectedFulfillmentCount = expectedFulfillmentCount
        
        (0x00...0xFF)
            .compactMap(MemoryController.init)
            .forEach { mbc in
                guard mbc.isValid else {
                    return
                }
                
                switch mbc.rawValue {
                case 0x00:
                    guard case .rom = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "ROM")
                    configsTested.fulfill()
                case 0x01:
                    guard case .one = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "MBC1")
                    configsTested.fulfill()
                case 0x02:
                    guard case .one = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram])
                    XCTAssertEqual(mbc.debugDescription, "MBC1+RAM")
                    configsTested.fulfill()
                case 0x03:
                    guard case .one = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery])
                    XCTAssertEqual(mbc.debugDescription, "MBC1+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x05:
                    guard case .two = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "MBC2")
                    configsTested.fulfill()
                case 0x06:
                    guard case .two = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.battery])
                    XCTAssertEqual(mbc.debugDescription, "MBC2+BATTERY")
                    configsTested.fulfill()
                case 0x08:
                    guard case .rom = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram])
                    XCTAssertEqual(mbc.debugDescription, "ROM+RAM")
                    configsTested.fulfill()
                case 0x09:
                    guard case .rom = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery])
                    XCTAssertEqual(mbc.debugDescription, "ROM+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x0B:
                    guard case .mmm1 = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "MMM1")
                    configsTested.fulfill()
                case 0x0C:
                    guard case .mmm1 = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram])
                    XCTAssertEqual(mbc.debugDescription, "MMM1+RAM")
                    configsTested.fulfill()
                case 0x0D:
                    guard case .mmm1 = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery])
                    XCTAssertEqual(mbc.debugDescription, "MMM1+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x0F:
                    guard case .three = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.timer, .battery])
                    XCTAssertEqual(mbc.debugDescription, "MBC3+TIMER+BATTERY")
                    configsTested.fulfill()
                case 0x10:
                    guard case .three = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .timer, .battery])
                    XCTAssertEqual(mbc.debugDescription, "MBC3+TIMER+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x11:
                    guard case .three = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "MBC3")
                    configsTested.fulfill()
                case 0x12:
                    guard case .three = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram])
                    XCTAssertEqual(mbc.debugDescription, "MBC3+RAM")
                    configsTested.fulfill()
                case 0x13:
                    guard case .three = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery])
                    XCTAssertEqual(mbc.debugDescription, "MBC3+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x19:
                    guard case .five = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "MBC5")
                    configsTested.fulfill()
                case 0x1A:
                    guard case .five = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram])
                    XCTAssertEqual(mbc.debugDescription, "MBC5+RAM")
                    configsTested.fulfill()
                case 0x1B:
                    guard case .five = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery])
                    XCTAssertEqual(mbc.debugDescription, "MBC5+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x1C:
                    guard case .five = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.rumble])
                    XCTAssertEqual(mbc.debugDescription, "MBC5+RUMBLE")
                    configsTested.fulfill()
                case 0x1D:
                    guard case .five = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .rumble])
                    XCTAssertEqual(mbc.debugDescription, "MBC5+RUMBLE+RAM")
                    configsTested.fulfill()
                case 0x1E:
                    guard case .five = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery, .rumble])
                    XCTAssertEqual(mbc.debugDescription, "MBC5+RUMBLE+RAM+BATTERY")
                    configsTested.fulfill()
                case 0x20:
                    guard case .six = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "MBC6")
                    configsTested.fulfill()
                case 0x22:
                    guard case .seven = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery, .rumble, .sensor])
                    XCTAssertEqual(mbc.debugDescription, "MBC7+SENSOR+RUMBLE+RAM+BATTERY")
                    configsTested.fulfill()
                case 0xFC:
                    guard case .camera = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.camera])
                    XCTAssertEqual(mbc.debugDescription, "POCKET CAMERA")
                    configsTested.fulfill()
                case 0xFD:
                    guard case .tama5 = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "BANDAI TAMA5")
                    configsTested.fulfill()
                case 0xFE:
                    guard case .huc3 = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [])
                    XCTAssertEqual(mbc.debugDescription, "HuC3")
                    configsTested.fulfill()
                case 0xFF:
                    guard case .huc1 = mbc else {
                        return XCTFail()
                    }
                    XCTAssertEqual(mbc.hardware, [.ram, .battery])
                    XCTAssertEqual(mbc.debugDescription, "HuC1+RAM+BATTERY")
                    configsTested.fulfill()
                default:
                    XCTFail("\(mbc) should not be possible.")
                }
        }
        XCTAssertEqual(XCTWaiter.wait(for: [configsTested], timeout: 0), .completed)
    }
    
    func testBadROMConfiguration() {
        let badConfig: MemoryController = .rom(ram: false, battery: true)
        XCTAssertFalse(badConfig.isValid)
        XCTAssertEqual(badConfig.rawValue, 0x0A)
    }
    
    func testBadMBC1Configuration() {
        let badConfig: MemoryController = .one(ram: false, battery: true)
        XCTAssertFalse(badConfig.isValid)
        XCTAssertEqual(badConfig.rawValue, 0x04)
    }
    
    func testBadMMM1Configuration() {
        let badConfig: MemoryController = .mmm1(ram: false, battery: true)
        XCTAssertFalse(badConfig.isValid)
        XCTAssertEqual(badConfig.rawValue, 0x0E)
    }
    
    func testBadMBC3Configuration() {
        let badConfig: MemoryController = .three(ram: false, battery: true, timer: false)
        XCTAssertFalse(badConfig.isValid)
        XCTAssertEqual(badConfig.rawValue, 0x14)
    }
    
    func testBadMBC5Configuration() {
        let badConfig: MemoryController = .five(ram: false, battery: true, rumble: false)
        XCTAssertFalse(badConfig.isValid)
        XCTAssertEqual(badConfig.rawValue, 0x1F)
    }
    
    func testUnknownConfiguration() {
        let badConfig: MemoryController = .unknown(value: 0x30)
        XCTAssertFalse(badConfig.isValid)
        XCTAssertEqual(badConfig.rawValue, 0x30)
    }
}
