import Foundation

extension GameboyClassic {
    public struct Header {
        private var bytes: Data
        
        public init(bytes: Data) {
            self.bytes = Data(bytes)
        }
        
        public var bootInstructions: Data {
            get {
                return bytes[0x0..<0x4]
            }
            set {
                guard newValue.count == 4 else {
                    return
                }
                bytes[0x0..<0x4] = newValue
            }
        }
        
        public var logo: Data {
            get {
                return bytes[0x4..<0x34]
            }
            set {
                bytes[0x4..<0x34] = GameboyClassic.logo
            }
        }
        
        public var title: String {
            get {
                var title = Data(bytes[0x34..<0x44])
                
                // Portions of 'title' got re-purposed by BigN post-GBC
                if colorMode == .exclusive {
                    title = title[0..<11]
                }
                
                return String(data: title.filter { $0 != 0 }, encoding: .ascii)!
            }
            set {
                guard var title = String(newValue.prefix(16)).data(using: .ascii) else {
                    return
                }
                
                guard colorMode != .exclusive else {
                    bytes[0x34..<0x3F] = title[0..<11]
                    return
                }
                
                bytes[0x34..<0x43] = title
            }
        }
        
        public var manufacturer: String {
            get {
                return bytes[0x3F..<0x43].map { String($0, radix: 16, uppercase: true)}.joined()
            }
            set {
                guard let value = newValue.data(using: .ascii), value.count == 4 else {
                    return
                }
                bytes[0x3F..<0x43] = value
            }
        }
        
        public var colorMode: GameboyClassic.ColorMode {
            get {
                return ColorMode(rawValue: bytes[0x43])
            }
            set {
                bytes[0x43] = newValue.rawValue
            }
        }
        
        public var licensee: String {
            return bytes[0x44..<0x46].map { String($0, radix: 16, uppercase: true)}.joined()
        }
        
        public var superGameboySupported: Bool {
            get {
                return bytes[0x46] == 0x03
            }
            set {
                guard newValue == true else {
                    bytes[0x46] = 0x00
                    return
                }
                bytes[0x46] = 0x03
            }
        }
        
        public var configuration: Gibby.MemoryController.Configuration {
            get {
                return .init(rawValue: bytes[0x47])
            }
            set {
                if case .unknown = newValue {
                    return
                }
                bytes[0x47] = newValue.rawValue
            }
        }
        
        public var romSizeID: UInt8 {
            return bytes[0x48]
        }
        
        public var ramSizeID: UInt8 {
            return bytes[0x49]
        }
        
        public var region: Region {
            get {
                return bytes[0x4A] != 0x00 ? "Non-Japanese" : "Japanese"
            }
            set {
                bytes[0x4A] = newValue.rawValue
            }
        }
        
        public var legacyLicensee: UInt8 {
            get {
                return bytes[0x4B]
            }
            set {
                bytes[0x4B] = newValue
            }
        }
        
        public var version: UInt8 {
            get {
                return bytes[0x4C]
            }
            set {
                bytes[0x4C] = newValue
            }
        }
        
        public var headerChecksum: UInt8 {
            return bytes[0x4D]
        }
        
        public var romChecksum: UInt16 {
            return UInt16(bytes[0x4E]).byteSwapped | UInt16(bytes[0x4F])
        }
    }
}

extension GameboyClassic.Header {
    enum Section: Int {
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
        
        private var size: Int {
            switch self {
            case .boot:             return 4
            case .logo:             return 48
            case .title:            return 16
            case .manufacturer:     return 4
            case .colorFlag:        return 1
            case .licensee:         return 2
            case .superGameboyFlag: return 1
            case .memoryController: return 1
            case .romSize:          return 1
            case .ramSize:          return 1
            case .region:           return 1
            case .legacyLicensee:   return 1
            case .versionMask:      return 1
            case .headerChecksum:   return 1
            case .cartChecksum:     return 2
            }
        }
        
        func range(offsetBy offset: Int = 0) -> Range<Int> {
            let lowerBound = rawValue.advanced(by: offset)
            let upperBound = lowerBound.advanced(by: size)
            return lowerBound..<upperBound
        }
        
        var rawValue: Int {
            switch self {
            case .boot:             return 0x00
            case .logo:             return 0x04
            case .title:            return 0x34
            case .manufacturer:     return 0x3F
            case .colorFlag:        return 0x43
            case .licensee:         return 0x44
            case .superGameboyFlag: return 0x46
            case .memoryController: return 0x47
            case .romSize:          return 0x48
            case .ramSize:          return 0x49
            case .region:           return 0x4A
            case .legacyLicensee:   return 0x4B
            case .versionMask:      return 0x4C
            case .headerChecksum:   return 0x4D
            case .cartChecksum:     return 0x4E
            }
        }
        
        init?(rawValue: Int) {
            guard let section = Section.allSections.filter({ $0.rawValue == rawValue }).first else {
                return nil
            }
            self = section
        }
        
        static var allSections: [Section] {
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
