import Foundation

/** TO-DO: `Header` & `Header.Section` should be system-specific. */
/** TO-DO: Support `read` & `write`...should be mutable / serializable */
public struct Header {
    public enum ColorMode: RawRepresentable, ExpressibleByIntegerLiteral, Codable {
        case exclusive
        case some
        case none
        case unknown(_ mode: Int)
        
        public var rawValue: Int {
            switch self {
            case .exclusive: return 0xC0
            case .some: return 0x80
            case .none: return 0x00
            case .unknown(let mode): return mode
            }
        }
        public init(rawValue: Int) {
            switch rawValue {
            case 0xC0: self = .exclusive
            case 0x80: self = .some
            case 0x00: self = .none
            default:
                self = .unknown(rawValue)
            }
        }
        
        public init(integerLiteral value: Int) {
            self.init(rawValue: value)
        }
    }
    
    public enum LegacyLicensee: RawRepresentable, Codable, ExpressibleByIntegerLiteral {
        case newFormat
        case legacy(code: Int)
        case none
        
        public var rawValue: Int {
            switch self {
            case .legacy(let code): return code
            case .newFormat: return 0x33
            case .none: return 0x00
            }
        }
        
        public init(rawValue: Int) {
            switch rawValue {
            case 0x33: self = .newFormat
            case 0x00: self = .none
            default: self = .legacy(code: rawValue)
            }
        }
        
        public init(integerLiteral value: Int) {
            self.init(rawValue: value)
        }
    }
    
    private let bytes: Data

    public init(bytes: Data /*, system: Gameboy */) {
        self.bytes = bytes
    }

    public var entryPoint: Data {
        return self.bytes[.boot]
    }
    public var isLogoValid: Bool {
        return self.bytes[.logo] == GameBoy.original.logo
    }
    public var title: String {
        var title = Data(self.bytes[.title])

        guard self.colorMode == .none else {
            guard !self.manufacturer.contains(" ") else {
                return String(data: title[..<15], encoding: .ascii)!
            }
            return String(data: title[..<11], encoding: .ascii)!
        }
        
        return String(data: title, encoding: .ascii)!
    }
    public var manufacturer: String {
        guard self.colorMode != .none else {
            return ""
        }
        return String(data: self.bytes[.manufacturer], encoding: .ascii)!
    }
    public var colorMode: ColorMode {
        guard let value = self.bytes[.colorFlag].first else {
            return .unknown(0x00)
        }
        return ColorMode(rawValue: Int(value))
    }
    public var licensee: String {
        let value = self.bytes[.licensee]
            .reversed()
            .reduce(into: UInt8()) { result, next in
                guard result != 0 else {
                    result = next
                    return
                }
                result -= next
        }
        
        return String(value, radix: 10, uppercase: true)
    }
    public var legacyLicensee: LegacyLicensee {
        return LegacyLicensee(rawValue: Int(self.bytes[.legacyLicensee].first ?? 0x00))
    }
    
    public var superGameboySupported: Bool {
        return (self.bytes[.superGameboyFlag].first ?? 0x00) == 0x03
    }
    
    public var memoryController: MemoryController {
        guard let value = self.bytes[.memoryController].first
            , let memoryController = MemoryController(rawValue: value) else {
                return .unknown(value: 0x00)
        }
        return memoryController
    }
    
    public var romSize: String {
        return self.bytes[.romSize].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    public var ramSize: String {
        return self.bytes[.ramSize].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    public var region: String {
        return ((self.bytes[.region].first ?? 0x00) == 0x01) ? "Non-Japanese" : "Japanese"
    }
    
    public var version: String {
        return self.bytes[.versionMask].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    public var headerChecksum: String {
        return self.bytes[.headerChecksum].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    public var cartChecksum: String {
        return self.bytes[.cartChecksum].map { String($0, radix: 16, uppercase: true) }.joined()
    }
}

extension Header {
    public enum Section: RawRepresentable {
        public enum HeaderAddress: RawRepresentable, ExpressibleByIntegerLiteral {
            case zero
            case cart
            case address(Int)
            
            public var rawValue: Int {
                switch self {
                case .zero: return 0x00
                case .cart: return 0x100
                case .address(let address): return address
                }
            }
            
            public init(rawValue: Int) {
                switch rawValue {
                case 0x00: self = .zero
                case 0x100: self = .cart
                default: self = .address(rawValue)
                }
            }
            
            public init(integerLiteral value: Int) {
                self.init(rawValue: value)
            }
        }
        indirect case beginning(at: HeaderAddress, Section)
        
        case boot
        case logo
        case title
        case manufacturer
        case colorFlag
        case licensee
        case superGameboyFlag
        case memoryController
        case romSize
        case ramSize
        case region
        case legacyLicensee
        case versionMask
        case headerChecksum
        case cartChecksum
        case invalid(Range<Int>)
        
        private func lowerBound(at address: HeaderAddress = .cart) -> Int {
            switch self {
            case .beginning(at: let address, let section): return section.lowerBound(at: address)
            case .boot:             return 0x00.advanced(by: address.rawValue)
            case .logo:             return 0x04.advanced(by: address.rawValue)
            case .title:            return 0x34.advanced(by: address.rawValue)
            case .manufacturer:     return 0x3F.advanced(by: address.rawValue)
            case .colorFlag:        return 0x43.advanced(by: address.rawValue)
            case .licensee:         return 0x44.advanced(by: address.rawValue)
            case .superGameboyFlag: return 0x46.advanced(by: address.rawValue)
            case .memoryController: return 0x47.advanced(by: address.rawValue)
            case .romSize:          return 0x48.advanced(by: address.rawValue)
            case .ramSize:          return 0x49.advanced(by: address.rawValue)
            case .region:           return 0x4A.advanced(by: address.rawValue)
            case .legacyLicensee:   return 0x4B.advanced(by: address.rawValue)
            case .versionMask:      return 0x4C.advanced(by: address.rawValue)
            case .headerChecksum:   return 0x4D.advanced(by: address.rawValue)
            case .cartChecksum:     return 0x4E.advanced(by: address.rawValue)
            case .invalid(let range): return range.lowerBound.advanced(by: address.rawValue)
            }
        }
        
        public var size: Int {
            switch self {
            case .beginning(at: _, let section): return section.size
            case .boot:             return 3
            case .logo:             return 48
            case .title:            return 16
            case .manufacturer:     return 4
            case .colorFlag:        return 1
            case .licensee:         return 2
            case .superGameboyFlag: return 1
            case .memoryController: return 1
            case .romSize:          return 1
            case .ramSize:          return 1
            case .region:           return 2
            case .legacyLicensee:   return 1
            case .versionMask:      return 1
            case .headerChecksum:   return 1
            case .cartChecksum:     return 2
            case .invalid(let range): return range.count
            }
        }
        
        /// Assumes range has a lower bound starting at `.cart` address (0x100).
        public var rawValue: Range<Int> {
            return lowerBound()..<lowerBound().advanced(by: size)
        }
        
        public init(rawValue: Range<Int>) {
            self = Section.allSections.filter({ $0.rawValue == rawValue }).first ?? .invalid(rawValue)
        }
        
        public init(rawValue: Range<Int>, headerAddress address: HeaderAddress) {
            guard address != .cart else {
                self = Section(rawValue: (rawValue.lowerBound.advanced(by: HeaderAddress.cart.rawValue)..<rawValue.upperBound.advanced(by: HeaderAddress.cart.rawValue)))
                return
            }
            self = Section.allSections
                .map    ({ .beginning(at: address, $0) })
                .filter ({ $0.rawValue == rawValue })
                .first  ?? .beginning(at: address, .invalid(rawValue))
        }
        
        public static var allSections: [Section] {
            return [
                .boot
                , .logo
                , .title
                , .manufacturer
                , .colorFlag
                , .licensee
                , .superGameboyFlag
                , .memoryController
                , .romSize
                , .ramSize
                , .region
                , .legacyLicensee
                , .versionMask
                , .headerChecksum
                , .cartChecksum
            ]
        }
    }
}

